% Find the difference between the quaternions of the predicted hand and the
% measurement.
% Input:
%   finger_k: the finger struct at time k
%   measurement: the measured quaternion at time k
% Output:
%   r: residual with its size equal to sensorNumx3


function r = residual(IMUOrient_k, measurement_k)

sensorNum = length(IMUOrient_k);        % Number of sensors/frames
r = zeros(sensorNum*3,1);               % Pre-allocate

for i = 1:sensorNum
    z = IMUOrient_k(i).inv*measurement_k(i);
    r(3*i-2: 3*i) = 2*(z.v)';
end