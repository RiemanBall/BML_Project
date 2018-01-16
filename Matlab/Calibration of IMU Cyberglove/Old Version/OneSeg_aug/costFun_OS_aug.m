function [f, g, H] = costFun_OS_aug( x_est, x_pred, output, constVarNum, M, V)
%% Find out the residual and the Jacobian
[~, IMUReadEst] = configUpdate_OS(x_est(1 : constVarNum), x_est(constVarNum+1 : end));    % Predict next motion
r = residual_OS(IMUReadEst, output);              % Compute the residual
J = jacob_OS_aug(r, x_est, output, constVarNum);  % Compute the Jacobian of the residual

f = 1/2 * ( r' / V * r + (x_est - x_pred)' / M * (x_est - x_pred));

if nargout > 1
    g = gradFun( x_est, x_pred, J, r, M, V );
    
    if nargout > 2
        H = J' / V * J + inv(M);
    end
end