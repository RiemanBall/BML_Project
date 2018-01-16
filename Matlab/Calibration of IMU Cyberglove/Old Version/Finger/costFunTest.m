function [f, g, H] = costFunTest( x_est, x_pred, output, frameNum, constStateNum, M, V)

constStates_est = x_est(1 : constStateNum);         % In a angle-axis form
TVStates_est = x_est(constStateNum+1 : end);        % Time-varying

%% Find out the residual and the Jacobian
[fingerEst, IMUEst] = configUpdate(constStates_est, TVStates_est, frameNum);        % Estimated motion
r = residual(IMUEst, output);                           % Compute the residual
J = jacob(r, x_est, fingerEst, IMUEst, output );        % Compute the Jacobian of the residual

f = 1/2 * ( r' / V * r + (x_est - x_pred)' / M * (x_est - x_pred));

if nargout > 1
    g = gradFun( x_est, x_pred, J, r, M, V);
    
    if nargout > 2
        
        H_inv = M - M*J'/(J*M*J' + V) * J * M;
        H = inv(H_inv);
    end
end