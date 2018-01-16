function [f, g] = costFun_vr2( x_est, x_pred, output, frameNum, constStateNum, M, V)

constStates_est = x_est(1 : constStateNum);         % In a angle-axis form
TVStates_est = x_est(constStateNum+1 : end);        % Time-varying

%% Find out the residual and the Jacobian
[fingerEst, IMUEst] = configUpdate(constStates_est, TVStates_est, frameNum);               % Estimated motion
r = residual_vr2(IMUEst, output);                             % Compute the residual
J = jacob_vr2(r, x_est, fingerEst, IMUEst, output );    % Compute the Jacobian of the residual

f = 1/2 * ( r' / V * r + (x_est - x_pred)' / M * (x_est - x_pred));

if nargout > 1
    g = gradFun( x_est, x_pred, J, r, M, V);
end