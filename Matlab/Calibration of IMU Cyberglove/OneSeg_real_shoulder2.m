clear
clc
close all

%% Preprocessing
k = 3500;
base = csvread('synDataFile_arm_base.csv', 0,2, [0,2,k-1,5]);
arm = csvread('synDataFile_arm_base.csv', 0,15, [0,15,k-1,18]);
joint_truth = csvread('synDataFile_arm_base.csv', 0, 29, [0,29,k-1,29]);
IMUOutput = repmat(Quaternion(), k, 1);

for i = 1:k
    base_qi = Quaternion(base(i, :));
    arm_qi = Quaternion(arm(i, :));
%     figure
%     base_qi.plot('color','b')
%     hold on
%     arm_qi.plot('color','r')
    
    IMUOutput(i) = base_qi.inv * arm_qi;
    IMUOutput(i) = IMUOutput(i).unit;
    figure
    IMUOutput(i).plot
end

%% Parameters
sensorNum = 2;
frameNum = 1;
constVarNum = sensorNum * 3;
TVVarNum = frameNum * 1;
varNum = constVarNum + TVVarNum;

stdDev_Config0 = d2r(10);
var_Config0 = stdDev_Config0^2;

stdDev_Placement0 = d2r(10);
var_Placement0 = stdDev_Placement0^2;

stdDev_measurement = d2r(0.3);
var_measurement = stdDev_measurement^2;

stdDev_whiteNoise = d2r(1);
var_whiteNoise = stdDev_whiteNoise^2;


%% Observability
rLength = 3 * frameNum;
O = zeros(rLength * (k-1), TVVarNum * (k-1) + constVarNum);
checkObsv = 0;


%% I.C.
% Roughly guess:
placement1Init = q2angvec(Quaternion( rotx(d2r(90)) * rotz(d2r(-30)) ));     % base sensor4
placement2Init = q2angvec(Quaternion( roty(d2r(-30)) ));                     % arm sensor5
% placement1Init = q2angvec(Quaternion( roty(d2r(-10)) ));                   % arm sensor5
% placement2Init = q2angvec(Quaternion( roty(d2r(-2)) * rotz(d2r(7)) ));     % base sensor4
% placement_initGuess = zeros(constVarNum, 1);
placement_initGuess = [placement1Init; placement2Init];
angle0 = -1.5;

x_est = zeros(varNum, k);
x_est(:, 1) = [placement_initGuess; angle0];

A = eye(varNum);

%% Fine Tuning
V_est = zeros(rLength);       % Estimated measurement noise covariance
V = var_measurement * eye(rLength);

% M
M_tune = [1e-3, 1e-3];
M = diag( [var_Placement0 * ones(1, constVarNum) * M_tune(1), var_Config0 * ones(1, TVVarNum)] * M_tune(2) );     % Initialize the a priori covariance of the states

% W
W_tol = var_whiteNoise * 1e0;
W_tune = [1e-3, 1e-3];
W = var_whiteNoise * diag( [ones(1, constVarNum) * W_tune(1), ones(1, TVVarNum) * W_tune(2) ] ) ;   % Process noise covariance with 9 const states and 4 time-varying states

%% Performance check
TVP = zeros(1,k);
TVP(1) = norm(diag(M(constVarNum + 1 : end, constVarNum + 1 : end)));

%% Recurssive Estimation
for i = 2 : k
    x_pred = x_est(:,i-1);
    x_est(:,i) = x_pred;
    x_est_i = x_est(:,i);
    output = IMUOutput(i);
    
    %% Built-in Optimization Function
    costFunh = @(x_est)costFun_OS_aug2( x_est, x_pred, output, constVarNum, M, V);
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est_i,~,~,~,~,hessian] = fminunc(costFunh, x_est_i, options);
    H_inv = inv(hessian);
    
    x_s1_est = x_est_i(1 : constVarNum);              % In a angle-axis form
    x_j1_est = x_est_i(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS_aug2(x_s1_est, x_j1_est);
    
    x_est(:,i) = x_est_i;
    
    % Update the variance of the motion
    if W(1) > W_tol
        W(1:constVarNum, 1:constVarNum) = W(1:constVarNum, 1:constVarNum) / i;
    end
    W(constVarNum + 1 : end, constVarNum + 1 : end) = diag(var(x_est(constVarNum + 1 : end, 1:i)'));
%     if i > 100
%         W(constVarNum + 1 : end, constVarNum + 1 : end) = diag(var(x_est(constVarNum + 1 : end, 1:i)'));
%     end
    
    % Update
    M = H_inv + W;
    TVP(i) = norm(diag(H_inv(constVarNum + 1 : end, constVarNum + 1 : end)));
    
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
% Base Sensor4
for i = 1:3
    plotNum = plotNum + 1;
    figure(plotNum)
    plot(1:k, x_est(i,:), 'r')
    title('Base: Sensor4 Placement angle-axis element-wise')
end

plotNum = plotNum + 1;
Sensor4PlotNum = plotNum;
figure(plotNum)
IMUPlacement1_quat = angvec2q(x_est(1:3, end));
IMUPlacement1_quat.plot('color', 'r', 'frame', 'est')
hold on
Placement1_initGuess = angvec2q(x_est(1:3, 1));
Placement1_initGuess.plot('color', 'k', 'frame', 'guess')

% Arm Sensor5
for i = 1 : 3
    plotNum = plotNum + 1;
    figure(plotNum)
    plot(1:k, x_est(i+3,:), 'r')
    title('Arm: Sensor5 Placement angle-axis element-wise')
end

plotNum = plotNum + 1;
figure(plotNum)
IMUPlacement2_quat = angvec2q(x_est(4:6, end));
IMUPlacement2_quat.plot('color', 'r', 'frame', 'est')
hold on
Placement2_initGuess = angvec2q(x_est(4:6, 1));
Placement2_initGuess.plot('color', 'k', 'frame', 'guess')
title('Arm: Sensor5 Placement')


% TV states
angle_est = zeros(1,k);
jointAxis_est = zeros(3,k);
for i = 1:k
    [maxMag, maxMagIndex] = max(abs(x_est(constVarNum + 1 : end, i)));
    angle_est(i) = sign(x_est(constVarNum + maxMagIndex, i) * jointAxis_initGuess(maxMagIndex)) * norm(x_est(constVarNum+1:end,i));
    jointAxis_est(:,i) = x_est(constVarNum+1:end, i) / angle_est(i);
end

figure(Sensor4PlotNum)
jointAxisEst = IMUPlacement1_quat * jointAxis_est(:,end);
plot3([0, jointAxisEst(1)], [0, jointAxisEst(2)], [0, jointAxisEst(3)], 'r-')
jointAxis_initGuess = IMUPlacement1_quat * jointAxis_initGuess(:);
plot3([0, jointAxis_initGuess(1)], [0, jointAxis_initGuess(2)], [0, jointAxis_initGuess(3)], 'k')
title('Base: Sensor4 Placement and Joint Axis Estimation')

% Joint Axis Estimation
% for i = 1:3
%     plotNum = plotNum + 1;
%     figure(plotNum)
%     plot(1:k, jointAxis_est(i,:), 'r')
%     title('JointAxis Estimation')
% end

% Tracking Performance
plotNum = plotNum + 1;
figure(plotNum)
plot(1:k, joint_truth, 'b', 1:k, angle_est, 'r')
title('Tracking Performance')

% Tracking Error
plotNum = plotNum + 1;
figure(plotNum)
error = joint_truth' - angle_est;
plot(1:k, error, 'r')
% hold on
% plot(1:k, 2*sqrt(abs(TVP)), 'b.', 1:k, -2*sqrt(abs(TVP)), 'b.') 
% title('Error with two sigma bound')

% Check Observability
% minEigO = eigs(O'*O,1, 'smallestabs');