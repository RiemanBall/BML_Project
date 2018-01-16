function H = myHessian( x_est, output, frameNum, constStateNum, M, V)

constStates_est = x_est(1 : constStateNum);         % In a angle-axis form
TVStates_est = x_est(constStateNum+1 : end);        % Time-varying

%% Find out the residual and the Jacobian
[fingerEst, IMUEst] = configUpdate(constStates_est, TVStates_est, frameNum);               % Estimated motion
r = residual_vr2(IMUEst, output);                             % Compute the residual
J = jacob_vr2(r, x_est, fingerEst, IMUEst, output );    % Compute the Jacobian of the residual

H_inv = M - M*J'/(J*M*J' + V) * J * M;
H = inv(H_inv);