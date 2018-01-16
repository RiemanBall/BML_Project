% Find the difference between the quaternions of the predicted hand and the
% measurement.
% Input:
%   IMUOrient: the estimated quaternion of the IMU orientation
%   measurement: the measured quaternion
% Output:
%   r: residual with its size equal to 3x1


function r = residual_OS(IMUOrient, measurement_k)

z = IMUOrient.inv * measurement_k;
r = 2*(z.v)';
