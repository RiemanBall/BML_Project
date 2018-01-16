function f = costFun( x_est, x_pred, r, M, V)

f = 1/2 * ( r' / V * r + (x_est - x_pred)' / M * (x_est - x_pred));