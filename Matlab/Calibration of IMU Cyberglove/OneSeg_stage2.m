close all

%% Second Iteration process - determine the time-varying states with the fixed const states
% r0 = residual(IMURead_est(1), IMUOutput(1));                       % Compute the initial residual
% rEnd = r_k;
% rRatio = norm(rEnd)/norm(r0);

%% State covariance, M
% M = rRatio * diag( [var_Placement0 * ones(1, constVarNum) * 1, (var_Config0 + var_Orient0) * ones(1, TVVarNum_stage2)] * 10 );

% When knowing the I.C. well
M = diag( [var_Placement0 * ones(1, constVarNum) * 1e-1, (var_Config0) * ones(1, TVVarNum_stage2)] * 1 );

%% Process noise, W
% W = var_whiteNoise * diag( [ones(1, constVarNum) * 1e-2, ones(1, TVVarNum_stage2) * 10 ] ) ;
% process = x_est1(end,:) .* jointAxis;
% W = diag( [var_whiteNoise * ones(1, constVarNum) * 1e-2, var(process') ] ) ;

% When knowing the I.C. well
W = diag( [ones(1, constVarNum) * var_whiteNoise * 1e-1, var_whiteNoise * ones(1, TVVarNum_stage2) * 1e2 ] ) ;

%% I.C.
x_est = zeros(varNum_stage2, k);                   % Set the initial estimates all zeros.
% x_est2(:,1) = [x_est1(1:constVarNum, stillK); x_est1(end, 2) * jointAxis];

% When knowing the I.C. well
x_est(:,1) = [placement_angvec'.* (1 + randn(3,1)); devAngle(end) * 0.8 * jointAxis];

% fixed_x_s1 = x_est1(1:constVarNum, stillK);       % Fix the convergent constant states
% fixed_x_s1 = placement_angvec';

for i = 2 : k
    x_pred = x_est(:,i-1);
    x_est(:,i) = x_pred;
    x_est_i = x_est(:,i);
    output = IMUOutput(i);
    
    %% Built-in Optimization Function
    costFunh = @(x_est)costFun_OS_Opt_stage2( x_est, x_pred, output, frameNum, constVarNum, M, V);
    options = optimoptions('fminunc', 'Algorithm', 'trust-region', 'SpecifyObjectiveGradient', true, 'HessianFcn', 'objective');
    options.MaxIterations = 1000;
    options.StepTolerance = 1e-8;
    
    [x_est_i,~,~,~,~,hessian] = fminunc(costFunh, x_est_i, options);
    H_inv = inv(hessian);
    
%         Jw = J(:, 1:constStateNum);
%         Jp = J(:, constStateNum+1:end);
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum * k+1 : end) = Jw;
%         O(rLength*(i-1)+1 : rLength*i, TVStateNum*(i-1)+1 : TVStateNum*i) = Jp;
%         if rank(Jp) < 4
%             checkObsv = false;
%         end

%     x_j1_est = x_est(constVarNum + 1 : end);        % Time-varying
%     [segOrientEst, IMUReadEst] = configUpdate_OS(fixed_x_s1, x_j1_est, frameNum);


    x_s1_est = x_est_i(1 : constVarNum);              % In a angle-axis form
    x_j1_est = x_est_i(constVarNum + 1 : end);        % Time-varying
    [segOrientEst, IMUReadEst] = configUpdate_OS(x_s1_est, x_j1_est);
    segOrient_est(i) = segOrientEst;
    IMURead_est(i) = IMUReadEst;
    
%     x_est2(:,i) = [fixed_x_s1; x_est(constVarNum+1 : end)];
    x_est(:,i) = x_est_i;
    
    % Estimate the variance of the motion
    W(1:constVarNum, 1:constVarNum) = W(1:constVarNum, 1:constVarNum)/i;
    
    % Update
    M = H_inv + W;
    
    % Estimate the measurement noise
    r_k = residual_OS(IMUReadEst, output);
    V_est = V_est + r_k * r_k' / (stillK - 1);
end


%% Verify the estimation of the time-varying states
plotNum = 7;
figure(plotNum)
title('Tracking Performance')
plot(1:stillK, angle(1 : stillK),'b', 1:stillK, x_est1(end,:), 'r')

% Placement angle-axis element-wise
for i = 1:3
    plotNum = plotNum + 1;
    figure(plotNum)
    title('Placement angle-axis element-wise')
    plot(1:stillK, x_est(i,:), 'r')
    hold on
    plot(1:stillK, ones(1, stillK) * placement_angvec(i), 'b')
end

% Joint Axis Estimation
angle_est = zeros(1,k);
jointAxis_est = zeros(3,k);
for i = 1:k
    [maxMag, maxMagIndex] = max(abs(x_est(constVarNum + 1 : end, i)));
    angle_est(i) = sign(x_est(constVarNum + maxMagIndex, i) * jointAxis(maxMagIndex)) * norm(x_est(constVarNum+1:end,i));
    jointAxis_est(:,i) = x_est(constVarNum+1:end, i) / angle_est(i);
end

for i = 1:3
    plotNum = plotNum + 1;
    figure(plotNum)
    title('JointAxis Estimation')
    plot(1:k, jointAngvec(i,1) / angle(1) * ones(1,k), 'b', 1:k, jointAxis_est(i,:), 'r')
end

% Tracking Performance
plotNum = plotNum + 1;
figure(plotNum)
title('Tracking Performance')
plot(1:k, angle, 'b', 1:k, angle_est, 'r')