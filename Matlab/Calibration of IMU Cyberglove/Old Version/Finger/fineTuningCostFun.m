function cost = fineTuningCostFun(diagonalM0, k, constStateNum, stateNum, frameNum, sensorNum, var_Placement0, var_TVStates, IMUOutput, q_Placement, V)
iterateNum = 10;
x_est1 = zeros(stateNum, k);
%% First Iteration process - determine the constant states
M0 = diag( [var_Placement0 * diagonalM0(1:constStateNum), var_TVStates * diagonalM0(constStateNum + 1 : end)] );
M = M0;
W = zeros(stateNum, stateNum);

for i = 2 : k
    x_pred = x_est1(:,i-1);        % Dynamics propagation
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
    x_est1(:,i) = x_est;
    % Estimate the variance of the motion
    jointDisplacement = diff(x_est1(constStateNum+1:end,1:i)');
    W(constStateNum+1:end, constStateNum+1:end) = diag(var(jointDisplacement));
    P = H_inv;
    M = P + W;
    
end

cost = 0;
q_constStateEst = angvec2q(x_est(1:constStateNum), 1e-4, sensorNum);

for i = 1:sensorNum
    q_error = q_constStateEst(i).inv * q_Placement(i);
    cost = cost + 2 * acos(q_error.s);
end

cost = log(cost);