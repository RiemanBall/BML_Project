% Simulate the noised measurement with biases and variance of the noise

function IMU_noised = measurement_OS(IMU_truth, bias, stdDev)

IMU_noised = IMU_truth;
k = size(IMU_truth,1);

for t = 1:k
    noise = ones(1,3) * bias + randn(1,3) * stdDev;
    q_error = r2q(noise);                          % Relative to the parent frame of the IMU
    IMU_noised(t,1) = IMU_noised(t,1) * q_error;
end
