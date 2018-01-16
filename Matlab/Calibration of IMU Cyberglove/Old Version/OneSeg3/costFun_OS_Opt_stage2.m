function [f, g, H] = costFun_OS_Opt_stage2( x_est, x_pred, output, frameNum, constVarNum, M, V)
% x_est(1:constVarNum) = fixed_x_s1;
x_s1 = x_est(1 : constVarNum);         % In a angle-axis form
x_j1 = x_est(constVarNum+1 : end);        % Time-varying

%% Find out the residual and the Jacobian
[~, IMUReadEst] = configUpdate_OS(x_s1, x_j1);    % Predict next motion
r = residual_OS(IMUReadEst, output);                        % Compute the residual
J = jacob_OS(r, x_est, output);                      % Compute the Jacobian of the residual

f = 1/2 * ( r' / V * r + (x_est - x_pred)' / M * (x_est - x_pred));

if nargout > 1
    g = gradFun( x_est, x_pred, J, r, M, V );
    
    if nargout > 2
        H = J' / V * J + inv(M);
    end
end