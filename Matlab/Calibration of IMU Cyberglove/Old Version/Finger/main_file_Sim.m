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
%       x = [x_w; x_p] for three joints and three sensors.
%       size(x) = 1x13;
%       
%
%       x_w contains all constant states, and x_p contains all the time-varying states.
%       
%       Assume x_w = [imuOrien]
%                   x_p = [jointAngle]
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
T = 10;        % Simulate 10 second
stillTime = 10;     % The time when the hand doesn't move
rate = 100;     % Sampling rate = 100 Hz
k = T*rate;     % Time index
stillK = stillTime * rate;
pLength_const = [5, 3, 1];            % Set the length of the user's phalanges
sensorNum = 3;
% handDOF = [2 1 1];                    % The proximal joint has 2 DOF
frameNum = 3;
constStateNum = sensorNum*3;
TVStateNum = frameNum*3;
stateNum = constStateNum + TVStateNum;          % In our case, 9 const IMU orientation states, 4 time-varying rotation angle states.

%% Create hand motion and ground-truth measurement
stdDev_Config0 = d2r(3);
var_Config0 = stdDev_Config0^2;
stdDev_Orient0 = d2r(10);
var_Orient0 = stdDev_Orient0^2;
stdDev_Placement0 = d2r(10);
var_Placement0 = stdDev_Placement0^2;

[placement_angvec, placement, fingerMoveAngvec, fingerMoveAngleMatrix, IMU_truth, finger_truth] = handMotion(k, frameNum, TVStateNum, stdDev_Config0, stdDev_Orient0, stdDev_Placement0);
RP = placement_angvec';

%% Hand motion animation
% motionPlot(finger_truth, IMU_truth, pLength_const)

%% Measurement
bias_measurement = d2r(0);
stdDev_measurement = d2r(0.1);
var_measurement = stdDev_measurement^2;
IMUOutput = measurement(IMU_truth, bias_measurement, stdDev_measurement);
rLength = 3*frameNum;

%% Observability
O = zeros(rLength*k, TVStateNum*k+constStateNum);
checkObsv = true;

%% Initialization of the estimate
x_est1 = zeros(stateNum, stillK);
x_est2 = zeros(stateNum, k);        % Set the initial estimates all zeros.
A = eye(stateNum);                  % Transition matrix
iterateNum = 10;
finger_est = repmat(repmat(Quaternion(),1,3),k,1);            % Initial estimated configuration of the finger is straight.
IMU_est = repmat(repmat(Quaternion(),1,3),k,1);               % Initial estimated configuration of the IMU is perfectly aligned with the finger.

%% Fine tuning
V_est = 0;       % Estimated measurement noise covariance
V = var_measurement * eye(3*frameNum,3*frameNum);
a = 1;
b = 1;
c = 1;
M0 = diag( [var_Placement0 * [ones(1,3)*a, ones(1,3)*b, ones(1,3)*c], (var_Config0 + var_Orient0) * ones(1, TVStateNum)] );       % Initialize the a priori covariance of the states
% M0 = diag( [1e-3*[ones(1,3)*a, ones(1,3)*b, ones(1,3)*c], (var_Config0 + var_Orient0) * ones(1, TVStateNum)] );
M = M0;
stdDev_whiteNoise = d2r(1);
var_whiteNoise = stdDev_whiteNoise^2;
% W = diag( [zeros(1, constStateNum) var_whiteNoise * ones(1, TVStateNum) ] ) ;   % Process noise covariance with 9 const states and 4 time-varying states
W = zeros(stateNum, stateNum);

%% First Iteration process - determine the constant states
for i = 2 : stillK
    x_pred = A * x_est1(:,i-1);        % Dynamics propagation
    x_est1(:,i) = x_pred;
    x_est = x_est1(:,i);
    output = IMUOutput(i,:);
    
%     for j = 1 : iterateNum    % Update/Iteration
%         constStates_est = x_est(1 : constStateNum);         % In a angle-axis form
%         TVStates_est = x_est(constStateNum+1 : end);        % Time-varying
% 
%         %% Find out the residual and the Jacobian
%         [fingerEst, IMUEst] = configUpdate(constStates_est, TVStates_est, frameNum);               % Estimated motion
%         r_k = residual(IMUEst, output);                             % Compute the residual
%         J = jacob(r_k, x_est, fingerEst, IMUEst, output );    % Compute the Jacobian of the residual
% 
%         %% Gauss-Newton method
%         gradient = gradFun( x_est, x_pred, J, r_k, M, V);               % Dimension: 13x1
%         H_inv = M - M*J'/(J*M*J' + V)*J*M;          % Matrix Inverse Lemma
%         h = - H_inv * gradient;
%         alpha = lineSearch(x_est, x_pred, output, J, r_k, h, M, V, frameNum, 'soft');
%         x_est = x_est + alpha * h;                      % Update the estimate
%     end
%     
%     finger_est(i,:) = fingerEst;
%     IMU_est(i,:) = IMUEst;

    costFunh = @(x_est)costFunTest( x_est, x_pred, output, frameNum, constStateNum, M, V);
    options = optimoptions('fminunc','Algorithm','trust-region',...
    'SpecifyObjectiveGradient',true,'HessianFcn','objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est,~,~,~,~,hessian] = fminunc(costFunh, x_est, options);
    H_inv = hessian;
    
    x_est1(:,i) = x_est;
    % Estimate the variance of the motion
    jointDisplacement = diff(x_est1(constStateNum+1:end,1:i)');
    W(constStateNum+1:end, constStateNum+1:end) = diag(var(jointDisplacement));
    P = H_inv;
    M = P + W;
    
end

%% Verify the estimation of the constant states
figNum = 1;
for i = 1:constStateNum
    figure(figNum)
    hold on
    plot(1:stillK, x_est1(i,1:stillK),'r')
    plot(1:stillK, RP(i)*ones(1,stillK),'b')
    legend('est','truth')
    figNum = figNum + 1;
end


%% Second Iteration process - determine the time-varying states with the fixed const states
r0 = residual(IMU_est(1,:), IMUOutput(1,:));                       % Compute the initial residual
rEnd = r_k;
rRatio = norm(rEnd)/norm(r0);

M = diag( [var_Placement0 * rRatio * [ones(1,3)*a, ones(1,3)*b, ones(1,3)*c], (var_Config0 + var_Orient0) * ones(1, TVStateNum)] );
% W = diag( [zeros(1, constStateNum) var_whiteNoise * ones(1, TVStateNum) ] );
W = zeros(stateNum, stateNum);

x_est2(:,1) = [x_est1(1:constStateNum,stillK); zeros(TVStateNum,1)];
constStates_est = x_est2(1:constStateNum,1);     % Fix the convergent constant states

for i = 2 : k
    x_pred = x_est2(:,i-1);
    x_est2(:,i) = x_pred;
    for j = 1:iterateNum    % Iteration
        TVStates_est = x_est2(constStateNum+1:end,i);     % Time-varying
        x_est2(1:constStateNum,i) = constStates_est;
        
        %% Find out the residual and Jacobian
        [finger_est(i,:), IMU_est(i,:)] = configUpdate(constStates_est, TVStates_est, frameNum);        % Estimated motion
        r_k = residual(IMU_est(i,:), IMUOutput(i,:));      % Compute the residual
        J = jacob(r_k, x_est2(:,i), finger_est(i,:), IMU_est(i,:), IMUOutput(i,:) );    % Compute the Jacobian of the residual
%         Jw = J(:, 1:constStateNum);
%         Jp = J(:, constStateNum+1:end);
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum * k+1 : end) = Jw;
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum*(i-1)+1 : TVStateNum*i) = Jp;
%         if rank(Jp) < 4
%             checkObsv = false;
%         end
        
        V_r = r_k * r_k';
        
        % Gauss-Newton method
        gradient = gradFun( x_est2(:,i), x_pred, J, r_k, M, V);        % Dimension: 13x1
        H_inv = M - M*J'/(J*M*J' + V)*J*M;
        h = - H_inv * gradient;
        alpha = lineSearch(x_est2(:,i), x_pred, IMUOutput(i,:), J, r_k, h, M, V, frameNum, 'soft');
        x_estTemp = x_est2(:,i) + alpha * h;
        x_est2(constStateNum+1:end,i) = x_estTemp(constStateNum+1:end);      %% Only update the time-varying part
    end
    
    
    % Estimate the variance of the motion
    jointDisplacement = diff(x_est2(constStateNum+1:end,1:i)');
    W(constStateNum+1:end, constStateNum+1:end) = diag(var(jointDisplacement));
    P = H_inv;
    M = P + W;
    V_est = V_est + V_r;
end


% Verify the estimation of the time-varying states
for i = 1:9
    figure(figNum)
    hold on
    plot(1:k, x_est2(constStateNum+i,:))
    plot(1:k, fingerMoveAngvec(i,:))
    legend('est','truth')
    figNum = figNum + 1;
end
