%%
clear;
clc;
close all;

%% Offline set - Load IMU data
% load('dataVideo1');
% y = dataVideo1;
% [k, sensorNum] = size(y);       % k is the time index
% sensorNum = sensorNum/4;

%% Simulation
% Initialization of Simulation
T = 20;        % Simulate 10 second
stillTime = 20;     % The time when the hand doesn't move
rate = 100;     % Sampling rate = 100 Hz
k = T*rate;     % Time index
stillK = stillTime * rate;
sensorNum = 2;
frameNum = 1;
constVarNum = sensorNum * 3;
TVVarNum_stage1 = frameNum * 1;
TVVarNum_stage2 = frameNum * 3;
varNum_stage1 = constVarNum + TVVarNum_stage1;
varNum_stage2 = constVarNum + TVVarNum_stage2;

%% Create hand motion and ground-truth measurement
% stdDev_Orient0 = d2r(10);
% var_Orient0 = stdDev_Orient0^2;

stdDev_Config0 = d2r(5);
var_Config0 = stdDev_Config0^2;

stdDev_Placement0 = d2r(5);
var_Placement0 = stdDev_Placement0^2;

[placement_angvec, jointAngvec, rotAngle, devAngle, IMU_truth, seg_truth] = segMotion_OS_aug(k, sensorNum, stdDev_Config0, stdDev_Placement0);

%% Hand motion animation
% motionPlot(1, seg_truth, IMU_truth)

%% Measurement
bias_measurement = d2r(0);
stdDev_measurement = d2r(0.1);
var_measurement = stdDev_measurement^2;
IMUOutput = measurement(IMU_truth, bias_measurement, stdDev_measurement);
rLength = 3 * frameNum;

%% Observability
O = zeros(rLength * (k-1), TVVarNum_stage2 * (k-1) + constVarNum);
checkObsv = 0;

%%
A = eye(varNum_stage2);          % Transition matrix
segOrient_est = repmat(Quaternion(),k,1);               % Initial estimated configuration of the finger is straight.
IMURead_est = repmat(Quaternion(),k,1);                     % Initial estimated configuration of the IMU is perfectly aligned with the finger.
% IMUPlacement_est = repmat(Quaternion(),k,1);

%% Fine tuning
V_est = zeros(TVVarNum_stage2);       % Estimated measurement noise covariance
V = var_measurement * eye(3 * frameNum, 3 * frameNum);

%% State covariance, M
% M = rRatio * diag( [var_Placement0 * ones(1, constVarNum) * 1, (var_Config0 + var_Orient0) * ones(1, TVVarNum_stage2)] * 10 );

% When knowing the I.C. well
M = diag( [var_Placement0 * ones(1, constVarNum) * 1e1, var_Config0 * ones(1, TVVarNum_stage2) * 1e1 ] );

%% Process noise, W
stdDev_whiteNoise = d2r(2);
var_whiteNoise = stdDev_whiteNoise^2;
% W = var_whiteNoise * diag( [ones(1, constVarNum) * 1e-2, ones(1, TVVarNum_stage2) * 10 ] ) ;
% process = x_est1(end,:) .* jointAxis;
% W = diag( [var_whiteNoise * ones(1, constVarNum) * 1e-2, var(process') ] ) ;

% When knowing the I.C. well
W = var_whiteNoise * diag( [ones(1, constVarNum) * 1e-2, ones(1, TVVarNum_stage2) * 1e-2 ] ) ;
W_tol = var_whiteNoise * 1e-1;

%% Initialization of the estimate
% When not knowing the I.C. well
x_est = zeros(varNum_stage2, k);
jointAxis_initGuess = jointAngvec(:,1)/rotAngle(1) .* (1 + 0.5 * randn(3,1)) ;
jointAxis_initGuess = jointAxis_initGuess / norm(jointAxis_initGuess);
placement_initGuess = zeros(constVarNum, 1);
angle_initGuess = rotAngle(1) * (1 + 0.5 * randn);

% When knowing the I.C. well
% placement_initGuess = placement_angvec';
% placement_initGuess = placement_initGuess(:) .* (1 + randn(constVarNum, 1));
% angle_initGuess = rotAngle(1) * (1 + 0.5 * randn);
x_est(:,1) = [placement_initGuess; angle_initGuess * jointAxis_initGuess];


for i = 2 : k
    x_pred = x_est(:,i-1);
    x_est(:,i) = x_pred;
    x_est_i = x_est(:,i);
    output = IMUOutput(i);
    
    %% Built-in Optimization Function
    costFunh = @(x_est)costFun_OS_aug( x_est, x_pred, output, constVarNum, M, V);
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est_i,~,~,~,~,hessian] = fminunc(costFunh, x_est_i, options);
    H_inv = inv(hessian);

    x_s1_est = x_est_i(1 : constVarNum);              % In a angle-axis form
    x_j1_est = x_est_i(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS(x_s1_est, x_j1_est);
    segOrient_est(i) = segOrientEst;
    IMURead_est(i) = IMUReadEst;
    
    x_est(:,i) = x_est_i;
    
    % Estimate the variance of the motion
    if W(1) > W_tol
        W(1:constVarNum, 1:constVarNum) = W(1:constVarNum, 1:constVarNum)/i;
    end
    W(constVarNum + 1 : end, constVarNum + 1 : end) = diag(var(x_est(7:end, :)'));
    
    % Update
    M = H_inv + W;
    
    % Estimate the measurement noise
    r_k = residual_OS(IMUReadEst, output);
    V_est = V_est + r_k * r_k' / (k - 1);
    
    % Obsv check
    J = jacob_OS_aug(r_k, x_est_i, output, constVarNum);
    Jw = J(:, 1:constVarNum);
    Jp = J(:, constVarNum+1:end);
    O(rLength*(i-2)+1 : rLength*(i-1), TVVarNum_stage2 * (k-1) + 1 : end) = Jw;
    O(rLength*(i-2)+1 : rLength*(i-1), TVVarNum_stage2 * (i-2) + 1 : TVVarNum_stage2 * (i-1)) = Jp;
    if rank(Jp) < TVVarNum_stage2
        checkObsv = checkObsv + 1;
    end
end


%% Verify the estimation of the time-varying states
plotNum = 1;
% Placement angle-axis element-wise
constAngleError = zeros(2,k);
truePlacement_quat = angvec2q([placement_angvec(1,:), placement_angvec(2,:)]);

for i = 1:k
    x_est_quati = angvec2q(x_est(1:constVarNum, i));
    for j = 1:2
        angleErrorQuat = x_est_quati(j) / truePlacement_quat(j);
        constAngleError(j,i) = norm(q2angvec(angleErrorQuat));
    end
end
figure(plotNum)
subplot(3, plotNum, 1)
plot(1:k, constAngleError(1,:))
subplot(3, plotNum, 2)
plot(1:k, constAngleError(2,:))
subplot(3, plotNum, 3)
plot(1:k, constAngleError(1,:) + constAngleError(2,:))

for i = 1:3
    plotNum = plotNum + 1;
    figure(plotNum)
    title('IMU1 Placement angle-axis element-wise')
    plot(1:k, x_est(i,:), 'r')
    hold on
    plot(1:k, ones(1, k) * placement_angvec(1, i), 'b')
end

for i = 1 : 3
    plotNum = plotNum + 1;
    figure(plotNum)
    title('IMU2 Placement angle-axis element-wise')
    plot(1:k, x_est(i,:), 'r')
    hold on
    plot(1:k, ones(1, k) * placement_angvec(2, i), 'b')
end

% TV states
angle_est = zeros(1,k);
jointAxis_est = zeros(3,k);
for i = 1:k
    [maxMag, maxMagIndex] = max(abs(x_est(constVarNum + 1 : end, i)));
    angle_est(i) = sign(x_est(constVarNum + maxMagIndex, i) * jointAxis_initGuess(maxMagIndex)) * norm(x_est(constVarNum+1:end,i));
    jointAxis_est(:,i) = x_est(constVarNum+1:end, i) / angle_est(i);
end

% Joint Axis Estimation
Axis_truth = zeros(3,1);
for i = 1:3
    Axis_truth(i) = jointAngvec(i,1) / rotAngle(1);
    plotNum = plotNum + 1;
    figure(plotNum)
    title('JointAxis Estimation')
    plot(1:k, Axis_truth(i) * ones(1,k), 'b', 1:k, jointAxis_est(i,:), 'r')
    axis([0,2000,Axis_truth(i)-0.3, Axis_truth(i)+0.3])
end

% Tracking Performance
plotNum = plotNum + 1;
figure(plotNum)
title('Tracking Performance')
plot(1:k, rotAngle, 'b', 1:k, angle_est, 'r')

var(x_est(7:end,:)')
var(jointAngvec')
TVW = zeros(3,k);
for i = 1:k
    TVW(:,i) = var(x_est(7:end, 1:i)');
end
minEigO = eigs(O*O',1, 'smallestabs');