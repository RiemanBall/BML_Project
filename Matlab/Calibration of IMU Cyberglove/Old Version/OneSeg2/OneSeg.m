% ---------Estimation of Hand Configuration with IMU------------
%
% Generative Observation Model:
%       y = F_x + v
%       
%       Assume for each IMU the output data is 4 by 1, yi = [quarternion]
%
% Generative State Model:
%       x = Ax + w              where A = I  in the paper
% 
%       x = [x_w; x_p] for 1 joint and 1 sensor.
%       size(x) = 6x1;
%       
%       x_w contains all constant states, and x_p contains all the time-varying states.
%       
%       Assume x_w = [imuOrien]
%              x_p = [jointAngle]
%
%       x_p is modelled as random walk:
%       x_p = x_p + w_p;
%
% Propagation of a priori:
%       x_bar = A*x_hat
%       M = A*P*A' + W



%% Real-time set - Read IMU data
% use_serial = true;
% 
% if use_serial == false
%     load('single_finger_grasp.mat')
% end
% 
% if ~isempty(instrfind)
%     clean_inst
% end
% close all
% 
% num_of_imu = 4;
% 
% o1 = [0;0;0];
% 
% if use_serial==true
%     s = serial('/dev/cu.usbmodem1421');
%     set(s,'BaudRate',115200);
%     %s.readasyncmode = 'continuous'
%     fopen(s);
% end
% %readasync(s);
% 
% format = ' %f %f %f %f ';
% for i = 1:num_of_imu - 1
%     format = strcat(format,format);
% end

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
sensorNum = 1;
frameNum = 1;
constVarNum = sensorNum * 3;
TVVarNum_stage1 = frameNum * 1;
TVVarNum_stage2 = frameNum * 3;
varNum_stage1 = constVarNum + TVVarNum_stage1;
varNum_stage2 = constVarNum + TVVarNum_stage2;

%% Create hand motion and ground-truth measurement
stdDev_Config0 = d2r(10);
var_Config0 = stdDev_Config0^2;

stdDev_Orient0 = d2r(10);
var_Orient0 = stdDev_Orient0^2;

stdDev_Placement0 = d2r(10);
var_Placement0 = stdDev_Placement0^2;

[placement_angvec, placement_quat, jointAngvec, angle, devAngle, IMU_truth, seg_truth] = segMotion_OS(k, frameNum, TVVarNum_stage1, stdDev_Config0, stdDev_Orient0, stdDev_Placement0);

%% Hand motion animation
% motionPlot(1, seg_truth, IMU_truth)

%% Measurement
bias_measurement = d2r(0);
stdDev_measurement = d2r(0.1);
var_measurement = stdDev_measurement^2;
IMUOutput = measurement(IMU_truth, bias_measurement, stdDev_measurement);
rLength = 3 * frameNum;

%% Observability
O = zeros(rLength * k, TVVarNum_stage1 * k + constVarNum);
checkObsv = true;

%% Initialization of the estimate
x_est1 = zeros(varNum_stage1, stillK);
%% When knowing the I.C. well
% x_est1(:,1) = [placement_angvec'.* (1 + 0.5 * randn(3,1)); devAngle(end) * 0.9];
% jointAxis = abs(jointAngvec(:,1))/norm(jointAngvec(:,1));
% jointAxis = (jointAxis + 0.02) / norm(jointAxis + 0.02);

%% When not knowing the I.C. well
% x_est1(:,1) = [placement_angvec'* 1.1; devAngle(end) * 0.9];
jointAxis = abs(jointAngvec(:,1))/norm(jointAngvec(:,1));
jointAxis = (jointAxis + 0.02) / norm(jointAxis + 0.02);

%%
A = eye(varNum_stage1);          % Transition matrix
segOrient_est = repmat(Quaternion(),k,1);               % Initial estimated configuration of the finger is straight.
IMURead_est = repmat(Quaternion(),k,1);                     % Initial estimated configuration of the IMU is perfectly aligned with the finger.
% IMUPlacement_est = repmat(Quaternion(),k,1);

%% Fine tuning
V_est = zeros(TVVarNum_stage1);       % Estimated measurement noise covariance
V = var_measurement * eye(3 * frameNum, 3 * frameNum);

%% MMMMMMMM
%% When knowing the I.C. well
% M = diag( [var_Placement0 * ones(1, constVarNum) * 1e-3, (var_Config0 + var_Orient0) * ones(1, TVVarNum)] * 1e-1 );       % Initialize the a priori covariance of the states

%% When not knowing the I.C. well
M = diag( [var_Placement0 * ones(1, constVarNum-1) * 1, (var_Config0 + var_Orient0) * ones(1, TVVarNum_stage1+1)] * 10 );

%% WWWWWWWW
stdDev_whiteNoise = d2r(1);
var_whiteNoise = stdDev_whiteNoise^2;
%% When knowing the I.C. well
% W = diag( [ones(1, constVarNum) * var_whiteNoise * 1e-5, var_whiteNoise * ones(1, TVVarNum) * 1e-1 ] ) ;   % Process noise covariance with 9 const states and 4 time-varying states

%% When not knowing the I.C. well
W = diag( [ones(1, constVarNum) * var_whiteNoise * 1e-3, var_whiteNoise * ones(1, TVVarNum_stage1) * 5e-1 ] ) ;

% W = eye(varNum) * stdDev_whiteNoise;

%%
P_norm = zeros(1, stillK);
P_norm(1) = norm(M);
jointDisplacement = ones(1, stillK);

%% First Iteration process - determine the constant states
for i = 2 : stillK
    x_pred = A * x_est1(:,i-1);        % Dynamics propagation
    x_est1(:,i) = x_pred;
    x_est = x_est1(:,i);
    output = IMUOutput(i);

%% Self-defined Optimization
%     for j = 1 : iterateNum    % Update/Iteration
%         x_s1_est = x_est(1 : constVarNum);              % In a angle-axis form
%         x_j1_est = x_est(constVarNum + 1 : end);        % Time-varying
% 
%         %% Find out the residual and the Jacobian
%         [segOrientEst, IMUReadEst] = configUpdate_OS(x_s1_est, x_j1_est, frameNum);         % Predict next motion
%         r_k = residual_OS(IMUReadEst, output);                                              % Compute the residual
%         J = jacob_OS(r_k, x_est, output);    % Compute the Jacobian of the residual
% 
%         %% Gauss-Newton method
%         gradient = gradFun( x_est, x_pred, J, r_k, M, V);               % Dimension: 13x1
%         H_inv = M - M * J' / (J * M * J' + V) * J * M;          % Matrix Inverse Lemma
%         h = - H_inv * gradient;
%         alpha = lineSearch(x_est, x_pred, output, J, r_k, h, M, V, frameNum, 'soft');
%         x_est = x_est + alpha * h;                  % Update the estimate
%     end

%% Built-in Optimization Function
    costFunh = @(x_est)costFun_OS_Opt_stage1( x_est, x_pred, output, frameNum, constVarNum, M, V, jointAxis);
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est,~,~,~,~,hessian] = fminunc(costFunh, x_est, options);
    H_inv = inv(hessian);
    
    x_s1_est = x_est(1 : constVarNum);              % In a angle-axis form
    x_j1_est = x_est(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS(x_s1_est, x_j1_est * jointAxis, frameNum);
    
    segOrient_est(i) = segOrientEst;
    IMURead_est(i) = IMUReadEst;
    
    x_est1(:,i) = x_est;
    
    % Estimate the variance of the motion
    W(1:constVarNum,1:constVarNum) = W(1:constVarNum,1:constVarNum)/i*10;
%     W(constVarNum+1 : end, constVarNum+1 : end) = diag(var(x_est1(constVarNum+1 : end, 1 : i), 0, 2));
%     jointDisplacement(i) = abs( (x_est1(end,i) - x_est1(end,i-1)) / jointDisplacement(i-1) );
%     W(end,end) = W(end,end) * jointDisplacement(i);
    
    % Update
    P_norm(i) = norm(H_inv);
    M = H_inv + W;
    
    % Estimate the measurement noise
    r_k = residual_OS(IMUReadEst, output);
    V_est = V_est + r_k * r_k' / (stillK - 1);
    
end

%% Verify the estimation of the constant states
r_placement = zeros(1, stillK);
r_segMove = zeros(1, stillK);
for i = 1 : stillK
    % Residual of IMU placement
    placementEst_quat = angvec2q(x_est1(1:3, i));
    r_placement_quat = placementEst_quat / placement_quat;
    r_placement(i) = acos(r_placement_quat.s) * 2;
    
    % Residual of segment move
    r_segMove(i) = abs(x_est1(end,i) - angle(i));
end

% % Residual of IMU placement
% figure(1)
% title('Residual of IMU placement')
% plot(1:stillK, r_placement(1 : stillK),'r')
% 
% % Residual of segment move
% figure(2)
% title('Residual of segment move')
% plot(1:stillK, r_segMove(1 : stillK), 'r')

% Placement angle-axis element-wise
for i = 1:3
    figure(3+i)
    title('Placement angle-axis element-wise')
    plot(1:stillK, x_est1(i,:), 'r')
    hold on
    plot(1:stillK, ones(1, stillK) * placement_angvec(i))
end

% Tracking Performance
figure(7)
title('Tracking Performance')
plot(1:stillK, angle(1 : stillK),'r', 1:stillK, x_est1(end,:), 'b')

%% Second Iteration process - determine the time-varying states with the fixed const states
r0 = residual(IMURead_est(1), IMUOutput(1));                       % Compute the initial residual
rEnd = r_k;
rRatio = norm(rEnd)/norm(r0);

%% MMMMMMMM
%% When knowing the I.C. well
% M = diag( [var_Placement0 * ones(1, constVarNum) * 1e-3, (var_Config0 + var_Orient0) * ones(1, TVVarNum)] * 1e-1 );       % Initialize the a priori covariance of the states

%% When not knowing the I.C. well
M = diag( [var_Placement0 * ones(1, constVarNum) * 1 * rRatio, (var_Config0 + var_Orient0) * ones(1, TVVarNum_stage2)] * 10 );

%% WWWWWWWW
stdDev_whiteNoise = d2r(1);
var_whiteNoise = stdDev_whiteNoise^2;
%% When knowing the I.C. well
% W = diag( [ones(1, constVarNum) * var_whiteNoise * 1e-5, var_whiteNoise * ones(1, TVVarNum) * 1e-1 ] ) ;   % Process noise covariance with 9 const states and 4 time-varying states

%% When not knowing the I.C. well
W = diag( [ones(1, constVarNum) * var_whiteNoise * 1e-3, var_whiteNoise * ones(1, TVVarNum_stage2) * 5e-1 ] ) ;

% W = eye(varNum) * stdDev_whiteNoise;

%%
x_est2 = zeros(varNum_stage2, k);               % Set the initial estimates all zeros.
fixed_x_s1 = x_est1(1:constVarNum, stillK);     % Fix the convergent constant states
x_est2(:,1) = [fixed_x_s1; x_est1(end, 1) * jointAxis];
% fixed_x_s1 = placement_angvec';

for i = 2 : k
    x_pred = x_est2(:,i-1);
    x_est2(:,i) = x_pred;
    x_est = x_est2(:,i);
    output = IMUOutput(i);
    
    %% Built-in Optimization Function
    costFunh = @(x_est)costFun_OS_Opt( x_est, x_pred, output, frameNum, constVarNum, M, V, fixed_x_s1);
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est,~,~,~,~,hessian] = fminunc(costFunh, x_est, options);
    H_inv = inv(hessian);
    
%         Jw = J(:, 1:constStateNum);
%         Jp = J(:, constStateNum+1:end);
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum * k+1 : end) = Jw;
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum*(i-1)+1 : TVStateNum*i) = Jp;
%         if rank(Jp) < 4
%             checkObsv = false;
%         end

    x_j1_est = x_est(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS(fixed_x_s1, x_j1_est, frameNum);
    segOrient_est(i) = segOrientEst;
    IMURead_est(i) = IMUReadEst;
    
    x_est2(:,i) = [fixed_x_s1; x_est(constVarNum+1 : 6)];
    
    % Estimate the variance of the motion
    W(1:constVarNum, 1:constVarNum) = W(1:constVarNum, 1:constVarNum)/i/5;
    
    % Update
    M = H_inv + W;
    
    % Estimate the measurement noise
    r_k = residual_OS(IMUReadEst, output);
    V_est = V_est + r_k * r_k' / (stillK - 1);
end


%% Verify the estimation of the time-varying states
r_segMove = zeros(1, k);

for i = 1 : k
    % Residual of segment move
    segMoveEst_quat = angvec2q(x_est1(4:end, i));
    r_segMove_quat = segMoveEst_quat / seg_truth(i);
    r_segMove(i) = acos(r_segMove_quat.s) * 2;
end

% Residual of segment move
figure(8)
title('Residual of segment move')
plot(1:k, r_segMove(:), 'r')

% Tracking Performance
figure(9)
title('Tracking Performance')
plot(1:k, angle,'r.', 1:k, x_est2(end,:), 'b-')