clear
clc
close all

%% Preprocessing
k = 2500;
startPoint = 1900;
forearm = csvread('synDataFile_arm_forearm3.csv', startPoint,2, [startPoint, 2, startPoint + k - 1, 5]);
arm = csvread('synDataFile_arm_forearm3.csv', startPoint,15, [startPoint, 15, startPoint + k - 1, 18]);
joint_truth = csvread('synDataFile_arm_forearm3.csv', startPoint, 31, [startPoint, 31, startPoint + k - 1, 31]);
IMUOutput = repmat(Quaternion(), k, 1);

for i = 1:k
    forearm_qi = Quaternion(forearm(i, :));
    arm_qi = Quaternion(arm(i, :));
    
    IMUOutput(i) = arm_qi.inv * forearm_qi;
    IMUOutput(i) = IMUOutput(i).unit;
%     figure(i)
%     IMUOutput(i).plot
end

%% Parameters
sensorNum = 2;
frameNum = 1;
constVarNum = sensorNum * 3;
TVVarNum = frameNum * 1;
varNum = constVarNum + TVVarNum;

stdDev_Config0 = d2r(20);
var_Config0 = stdDev_Config0^2;

stdDev_Placement0 = d2r(20);
var_Placement0 = stdDev_Placement0^2;

stdDev_measurement = d2r(0.1);
var_measurement = stdDev_measurement^2;

stdDev_whiteNoise = d2r(1);
var_whiteNoise = stdDev_whiteNoise^2;


%% Observability
rLength = 3 * frameNum;
O = zeros(rLength * (k-1), TVVarNum * (k-1) + constVarNum);
checkObsv = 0;


%% I.C.
% Roughly guess:
placement1Init = q2angvec(Quaternion( roty(d2r(-25+20)) ));                % arm sensor5
placement2Init = q2angvec(Quaternion( rotz(d2r(-21+20)) ));                % forearm sensor4
% placement1Init = q2angvec(Quaternion( roty(d2r(-10)) ));                   % arm sensor5
% placement2Init = q2angvec(Quaternion( roty(d2r(-2)) * rotz(d2r(7)) ));     % base sensor4
% placement_initGuess = zeros(constVarNum, 1);
placement_initGuess = [placement1Init; placement2Init];
angle0 = 0.1;

x_est = zeros(varNum, k);
x_est(:, 1) = [placement_initGuess; angle0];

A = eye(varNum);

%% Fine Tuning
V_est = zeros(rLength);       % Estimated measurement noise covariance
V = var_measurement * eye(rLength);

% M
M_tune = [1e0, 1e0];    % [1e0, 1e0];
M = diag( [var_Placement0 * ones(1, constVarNum) * M_tune(1), var_Config0 * ones(1, TVVarNum)] * M_tune(2) );     % Initialize the a priori covariance of the states

% W
W_tune = [1e-1, 5e1];    % [1e-1, 5e1];
W = var_whiteNoise * diag( [ones(1, constVarNum) * W_tune(1), ones(1, TVVarNum) * W_tune(2) ] ) ;   % Process noise covariance with 9 const states and 4 time-varying states
% constW_tol = var_whiteNoise * 1e-2;
% TVW_tol = var_whiteNoise * 1e0;

%% Performance check
TVP = zeros(1,k);
TVP(1) = M(end);

%% Recurssive Estimation
for i = 2 : k
    x_pred = x_est(:,i-1);
    x_est(:,i) = x_pred;
    x_est_i = x_est(:,i);
    output = IMUOutput(i);
    
    %% Built-in Optimization Function
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.StepTolerance = 1e-8;
    if i < k
        costFunh = @(x_est)costFun_OS_aug2( x_est, x_pred, output, constVarNum, M, V);
        options.MaxIterations = 1000;
    else
        costFunh = @(x_est)costFun_OS_aug2( x_est, x_pred, output, constVarNum, M, V, x_est(1:constVarNum));
        options.MaxIterations = 10;
    end
    
    [x_est_i,~,~,~,~,hessian] = fminunc(costFunh, x_est_i, options);
    
    
    H_inv = inv(hessian);
    
    x_s1_est = x_est_i(1 : constVarNum);              % In a angle-axis form
    x_j1_est = x_est_i(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS_aug2(x_s1_est, x_j1_est);
    
    if i < k
        x_est(:,i) = x_est_i;
    else
        x_est(end,i) = x_est_i(end);
    end
    
%     x_est(:,i) = x_est_i;
    
    % Update the variance of the motion
%     if W(1) > constW_tol
%         W(1:constVarNum, 1:constVarNum) = W(1:constVarNum, 1:constVarNum) / i * 15;
%     end
    
%     W(constVarNum + 1 : end, constVarNum + 1 : end) = diag(var(x_est(constVarNum + 1 : end, :)'));

%     W(end) = max(var(x_est(end, :)), TVW_tol);
    
    
    % Update
    M = H_inv + W;
    TVP(i) = H_inv(end);
    
    % Estimate the measurement noise
    r_k = residual_OS(IMUReadEst, output);
    V_est = V_est + r_k * r_k' / (k - 1);
    
    % Obsv check
    J = jacob_OS_aug2(r_k, x_est_i, output, constVarNum);
    Jw = J(:, 1 : constVarNum);
    Jp = J(:, constVarNum + 1 : end);
    O(rLength*(i-2)+1 : rLength*(i-1), TVVarNum * (k-1) + 1 : end) = Jw;
    O(rLength*(i-2)+1 : rLength*(i-1), TVVarNum * (i-2) + 1 : TVVarNum * (i-1)) = Jp;
    if rank(Jp) < TVVarNum
        checkObsv = checkObsv + 1;
    end
end


%% Verify the estimation of the time-varying states
plotNum = 0;

% Placement angle-axis element-wise
% Arm: Sensor5
for i = 1:3
    plotNum = plotNum + 1;
    figure(plotNum)
    plot(1:k, x_est(i,:), 'r')
    title('Arm: Sensor1 Placement angle-axis element-wise','FontSize',20)
    set(gca,'FontSize',18)
end

plotNum = plotNum + 1;
rootSensorPlotNum = plotNum;
figure(plotNum)
IMUPlacement1_quat = angvec2q(x_est(1:3, end));
IMUPlacement1_quat.plot('color', 'r', 'frame', 'est')
hold on
Placement1_initGuess = angvec2q(x_est(1:3, 1));
Placement1_initGuess.plot('color', 'k', 'frame', 'guess')
title('Arm: Sensor1 Placement','FontSize',20)
set(gca,'FontSize',18)

% Forearm: Sensor4
for i = 1 : 3
    plotNum = plotNum + 1;
    figure(plotNum)
    plot(1:k, x_est(i+3,:), 'r')
    title('Forearm: Sensor2 Placement angle-axis element-wise','FontSize',20)
    set(gca,'FontSize',18)
end

plotNum = plotNum + 1;
figure(plotNum)
IMUPlacement2_quat = angvec2q(x_est(4:6, end));
IMUPlacement2_quat.plot('color', 'r', 'frame', 'est')
hold on
Placement2_initGuess = angvec2q(x_est(4:6, 1));
Placement2_initGuess.plot('color', 'k', 'frame', 'guess')
title('Forearm: Sensor2 Placement','FontSize',20)
set(gca,'FontSize',18)


% TV states
% Tracking Performance
plotNum = plotNum + 1;
figure(plotNum)
plot(1:k, joint_truth, 'b', 1:k, x_est(constVarNum+1 : end, :), 'r')
xlabel('time (ms)','FontSize',20)
ylabel('angle (rad)','FontSize',20)
title('Tracking Performance','FontSize',20)
set(gca,'FontSize',18)

% Tracking Error
plotNum = plotNum + 1;
figure(plotNum)
error = joint_truth' - x_est(constVarNum+1 : end, :);
plot(1:k, error, 'r')
hold on
plot(1:k, 2*sqrt(abs(TVP)), 'b', 1:k, -2*sqrt(abs(TVP)), 'b')
title('Error with 2\sigma bound','FontSize',20)
set(gca,'FontSize',18)
legend({'Error','2\sigma bound'},'FontSize',20)

% Check Observability
minEigO = eigs(O'*O,1, 'smallestabs')