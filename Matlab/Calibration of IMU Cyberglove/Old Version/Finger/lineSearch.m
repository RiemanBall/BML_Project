% Line Search Algorithm: finding the step size
% Decide how long the step in the direction of h and with fixed x_est
% should be. Too large alpha will lead to an inaccurate appoximation of the
% Taylor expansion.
% 
% Soft line search: fast and computationally efficient
%   We use the Wolfe Conditions which contain the Armijo condition and the
%   strong Curvature condition.
% 
% Exact line search
% 

function alpha = lineSearch(x_est, x_pred, IMUOutputOrient, J0, r0, h, M, V, frameNum, type)

% Self-defining parameters
alphaMax = 8;
c1 = 1e-4;              % 0 < c1 < 0.5
c2 = 0.9;                % 0 < c1 < c2 < 1. The larger the c2 is, the "looser" the search is.
kMax = 10;

k = 0;
a = 0;
b = min(1, alphaMax);

phi0 = costFun(x_est, x_pred, r0, M, V);
dPhi0 = gradFun(x_est, x_pred, J0, r0, M, V, h);
dPhiCriteria =  c2 *  dPhi0;                                     % The curvature condition

lemdaFunh = @(alpha) phi0 + c1 * dPhi0 * alpha;

% See what the function of alpha looks like
% tsize = 500;
% ttPhi = zeros(tsize,1);
% for i = 1:tsize
%     [ttPhi(i), ~, ~] = parameters(x_est, x_pred, M, V, 0.01*i, h, frameNum, IMUOutputOrient, lemdaFunh);
% end
% plot(1:tsize,ttPhi)
% [ttmin,ttk] = min(ttPhi)

%% Line Search Process
switch type
    case 'soft'
        if dPhi0 >= 0           % If x is a stationary point or h is not downhill direction
            alpha = 0;
        else
            %% Increasing alpha until it finds either an acceptable step length or an interval that brackets the desired step lengths.
            % b is the first trial of alpha.
            [phiOfb, dPhiOfb, lemdaOfb] = parameters(x_est, x_pred, M, V, b, h, frameNum, IMUOutputOrient, lemdaFunh);
            
            while (phiOfb <= lemdaOfb) && (abs(dPhiOfb) <= abs(dPhiCriteria)) && (b < alphaMax) && (k < kMax)     % If the guess of alpha satisfies the condition
                % move the interval toward larger number
                k = k + 1;
                a = b;
                b = min(2*b, alphaMax);         % Extrapolation: simply set the next alpha to some constant multiple of the current alpha
                
                [phiOfb, dPhiOfb, lemdaOfb] = parameters(x_est, x_pred, M, V, b, h, frameNum, IMUOutputOrient, lemdaFunh);
            end
            alpha = b;
            
            %% Refine alpha and [a,b] - decrease the size of the interval until an acceptable step length is identified.
            [phiOfAlpha, dPhiOfAlpha, lemdaOfAlpha] = parameters(x_est, x_pred, M, V, b, h, frameNum, IMUOutputOrient, lemdaFunh);
           
            % If the current alpha doen't satisfy the conditions, refining the value of alpha
            while ((phiOfAlpha > lemdaOfAlpha) || (abs(dPhiOfAlpha) > abs(dPhiCriteria) )) && (k < kMax)    
                k = k + 1;
                % Refine
                [phiOfa, dPhiOfa, ~] = parameters(x_est, x_pred, M, V, a, h, frameNum, IMUOutputOrient, lemdaFunh);
                [phiOfb, ~, ~] = parameters(x_est, x_pred, M, V, b, h, frameNum, IMUOutputOrient, lemdaFunh);
                D = b - a;
                C = (phiOfb - phiOfa - D * dPhiOfa)/D^2;
                if C > 0
                    alpha = a - dPhiOfa/(2*C);
                else
                    alpha = (a + b)/2;
                end

                [phiOfAlpha, dPhiOfAlpha, lemdaOfAlpha] = parameters(x_est, x_pred, M, V, alpha, h, frameNum, IMUOutputOrient, lemdaFunh);
                
                [~, minIndex] = min([phiOfa, phiOfb, phiOfAlpha]);
                
                switch(minIndex)
                    case 1
                        if alpha < a || alpha > b
                            alpha = (a + b)/2;
                        end
                        b = alpha;
                    case 2
                        if alpha < a || alpha > b
                            alpha = (a + b)/2;
                        end
                        a = alpha;
                    case 3
                        if phiOfa > phiOfb
                            a = alpha;
                        else
                            b = alpha;
                        end
                end
            end
            
            %% Make sure the cost function will decrease
            if phiOfAlpha >= phi0
                alpha = 0;
            end
        end
        
    case 'exact'
        % Skip for now
end
end


% function [alpha_new, a_new, b_new, phiOfAlpha, dPhiOfAlpha, lemdaOfAlpha] = refine(a, b, phiOfa, phiOfb, dPhiOfa, x_est, x_pred, M, V, h, frameNum, IMUOutputOrient, lemdaFunh)
%     D = b - a;
%     C = (phiOfb - phiOfa - D * dPhiOfa)/D^2;
%     
%     if C > 0
%         alpha_new = a - dPhiOfa/(2*C);
%     else
%         alpha_new = (a + b)/2;
%     end
%     
%     [phiOfAlpha, dPhiOfAlpha, lemdaOfAlpha] = parameters(x_est, x_pred, M, V, alpha_new, h, frameNum, IMUOutputOrient, lemdaFunh);
%     
%     if phiOfAlpha < lemdaOfAlpha
%         a_new = alpha_new;
%         b_new = b;
%     else
%         a_new = a;
%         b_new = alpha_new;
%     end
% end


function [phi, dPhi, lemda] = parameters(x_est, x_pred, M, V, alpha, h, frameNum, IMUOutputOrient, lemdaFunh)
    x_est = x_est + alpha * h;
    constStates_est = x_est(1 : frameNum*3);
    TVStates_est = x_est(frameNum*3+1 : end);
    [fingerOrient_est, IMUOrient_est] = configUpdate(constStates_est, TVStates_est, frameNum);
    r = residual(IMUOrient_est, IMUOutputOrient);                       
    J= jacob(r, x_est, fingerOrient_est, IMUOrient_est, IMUOutputOrient);
    
    phi = costFun(x_est, x_pred, r, M, V);
    dPhi = gradFun(x_est, x_pred, J, r, M, V, h);
    lemda = lemdaFunh(alpha);
end