% Simulate the noised measurement with biases and variance of the noise

function IMU_noise = measurement(IMU_truth, bias_Degree, stdDev_Degree)

bias = d2r(bias_Degree);
stDev = d2r(stdDev_Degree);
IMU_noise = IMU_truth;
k = size(IMU_truth,1);
frameNum = length(IMU_truth(1,:));

for t = 1:k
    for i = 1:frameNum
        noise = randn(1,3)*bias + randn(1,3)*stDev;
        q_error = r2q(noise);                          % Relative to the parent frame of the IMU
        IMU_noise(t,i) = IMU_noise(t,i) * q_error;
    end
end
