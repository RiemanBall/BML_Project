% The cost function for the nonlinear optimization
% Input:
%   deviation: a (sensorNum by 4) matrix where each row represents a
%   quaternion.
%   data: the output of the IMUs in the Quaternion type
%   tol: the tolerance for computing the rank
% Output:
%   cost: the cost value

function cost = costFun_IMU(deviation, data)
sensorNum = size(deviation,1);
k = size(data,1);
qd = repmat(Quaternion(), 1, sensorNum);    % Pre-allocate the qd Quaternion vector
qd_inv = qd;
M = zeros(sensorNum, 3);
cost = 0;

for i = 1:k
    for j = 1:sensorNum
        qd(j) = Quaternion(deviation(j,:));
        qd_inv(j) = qd(j).inv;
        q0 = data(i,j) * qd_inv(j);     % q0 represents the ideal orientation of the IMU should be relative to the global frame
        zAxis = q0 * [0,0,1];
        M(j, :) = zAxis';
    end
    cost = cost + (3 - (dot(M(1,:),M(2,:)) + dot(M(1,:),M(3,:)) + dot(M(3,:),M(2,:))));
end
cost = log(cost);