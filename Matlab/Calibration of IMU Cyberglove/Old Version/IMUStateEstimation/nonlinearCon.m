% The nonlinear constrain is:
%   1. The norm of each quaternion equals 1
%   2. For each quaternion, the computed angle in the scalar term is same
%      as the one in the vector term.

function [n, neq] = nonlinearCon(qd)
n = [];
neq = [norm(qd(1,:)), norm(qd(2,:)), norm(qd(3,:)), acos(qd(1,1)), acos(qd(2,1)), acos(qd(3,1))]...
    - [ones(1,3), asin(norm(qd(1,2:end))), asin(norm(qd(2,2:end))), asin(norm(qd(3,2:end)))];
