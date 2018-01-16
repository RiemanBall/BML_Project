function g = gradFun( x_est, x_pred, J, r, M, V, h)
if nargin == 6
    h = 1;
end

g = h' * (J' / V * r + M \ (x_est - x_pred));