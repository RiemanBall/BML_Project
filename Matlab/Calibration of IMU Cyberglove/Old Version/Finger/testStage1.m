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
stillTime = 0.1;     % The time when the hand doesn't move
rate = 100;     % Sampling rate = 100 Hz
k = T*rate;     % Time index
stillK = stillTime * rate;
pLength_const = [5, 3, 1];          % Set the length of the user's phalanges
sensorNum = 3;
frameNum = 3;
constStateNum = sensorNum*3;
TVStateNum = frameNum*3;
stateNum = constStateNum + TVStateNum;          % In our case, 9 const IMU orientation states, 4 time-varying rotation angle states.

acc = zeros(3,400);
record = zeros(5, 400);
recordIndex = 1;
figNum = 1;

%% Fine tuning
for a = 0.4:0.01:0.5
    for b = 70:85
        for c = 25:5:70
            tic
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
            A = eye(stateNum);          % Transition matrix
            iterateNum = 10;
            finger_est = repmat(repmat(Quaternion(),1,3),k,1);            % Initial estimated configuration of the finger is straight.
            IMU_est = repmat(repmat(Quaternion(),1,3),k,1);               % Initial estimated configuration of the IMU is perfectly aligned with the finger.

            % Fine tuning
            V_est = 0;       % Estimated measurement noise covariance
            V = var_measurement * eye(3*frameNum,3*frameNum);
            

            %% First Iteration process - determine the constant states
            M0 = diag( [var_Placement0 * [ones(1,3)*a, ones(1,3)*b, ones(1,3)*c], (var_Config0 + var_Orient0) * ones(1, TVStateNum)] );       % Initialize the a priori covariance of the states
            M = M0;
            % W = diag([zeros(1, constStateNum) d2r(0.1*ones(1, TVStateNum))]);   % Process noise covariance with 9 const states and 4 time-varying states
            W = zeros(stateNum, stateNum);
            for i = 2 : stillK
                x_pred = A * x_est1(:,i-1);        % Dynamics propagation
                x_est1(:,i) = x_pred;
                x_est = x_est1(:,i);
                output = IMUOutput(i,:);

                for j = 1 : iterateNum    % Update/Iteration
                    constStates_est = x_est(1 : constStateNum);         % In a angle-axis form
                    TVStates_est = x_est(constStateNum+1 : end);        % Time-varying

                    %% Find out the residual and the Jacobian
                    [fingerEst, IMUEst] = configUpdate(constStates_est, TVStates_est, frameNum);               % Estimated motion
                    r_k = residual(IMUEst, output);                             % Compute the residual
                    J = jacob(r_k, x_est, fingerEst, IMUEst, output );    % Compute the Jacobian of the residual

                    %% Gauss-Newton method
                    gradient = gradFun( x_est, x_pred, J, r_k, M, V);               % Dimension: 13x1
                    H_inv = M - M*J'/(J*M*J' + V)*J*M;          % Matrix Inverse Lemma
                    h = - H_inv * gradient;
                    alpha = lineSearch(x_est, x_pred, output, J, r_k, h, M, V, frameNum, 'soft');
                    x_est = x_est + alpha * h;                      % Update the estimate
                end

                finger_est(i,:) = fingerEst;
                IMU_est(i,:) = IMUEst;
                x_est1(:,i) = x_est;
                % Estimate the variance of the motion
                jointDisplacement = diff(x_est1(constStateNum+1:end,1:i)');
                W(constStateNum+1:end, constStateNum+1:end) = diag(var(jointDisplacement));
                P = H_inv;
                M = P + W;

            end

            absError = abs(RP(:) - x_est1(1:constStateNum,stillK));
            absErrorBoolean = absError < 0.03;
            accNum1 = sum(absErrorBoolean);
            absErrorPercent = absError./abs(RP(:));
            absErrorPercentBoolean = absErrorPercent < 0.1;
            accNum2 = sum(absErrorPercentBoolean);
            
            if accNum1 > accNum2
                accNum = [1; accNum1];
                acc(:,recordIndex) = sum(reshape(absErrorBoolean,[3,3]),2);
            else
                accNum = [2; accNum2];
                acc(:,recordIndex) = sum(reshape(absErrorPercentBoolean,[3,3]),2);
            end
            
            record(:,recordIndex) = [accNum ; a ; b ; c];
            if accNum(2) > 7
                save(strcat('goodData',num2str(recordIndex)));
                for i = 1:constStateNum
                    p = figure(figNum);
                    hold on
                    plot(1:stillK, x_est1(i,1:stillK),'r')
                    plot(1:stillK, RP(i)*ones(1,stillK),'b')
                    legend('est','truth')
                    saveas(p, strcat('goodPlot',num2str(recordIndex),'-',num2str(i)))
                    figNum = figNum + 1;
                    close all;
                end
            end
            save('record', 'record','acc');
            recordIndex = recordIndex + 1;
            
            toc
        end
    end
end