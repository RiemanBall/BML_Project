% Initialize the orientation of the finger and the true orientation of the
% IMUs in terms of quaternion.

function [placement_angvec, placement_quat, jointAngvec, angle, devAngle, IMU_truth, seg_truth] = segMotion_OS(k, frameNum, TVVarNum, stdDev_Config0, stdDev_Orient0, stdDev_Placement0)

%% Initialization
seg_truth = repmat(Quaternion(),k,1);   % For now, the segment is perfectly straight and along with the global frame.
IMU_truth = seg_truth;                  % For now, the IMUs are perfectly aligned with the finger.

%% Set the initial configureation of the finger
segConfig0 = [0, 0, randn] * stdDev_Config0;        % Random deviation from the straight configuration in rad unit
% q_handConfig0 = r2q(handConfig0);                 % The deviation is w.r.t. the frame of the last joint (parent joint).

segOrient0 = randn(1,3) * stdDev_Orient0;           % Random deviation of the proximal frame from the global frame
segOrient0_quat = r2q(segOrient0);

%% Set the deviation of the IMU from its parent frame
placement = randn(frameNum, 3) * stdDev_Placement0;     % Misplacement with rotation angles w.r.t x-, y-, and z-axis of each sensor's parent joint frame.
placement_quat = r2q(placement);
placement_angvec = rotAngle2angvec(placement);

%% Create random hand motion
degreeRange = 45;                   % The range of the joint within which the segment is able to move.
jointAngvec = zeros(3, k);
angle = zeros(1, k);
angle(2:end) = d2r(randMotion_OS(k-1, degreeRange));
jointAngvec(end, 2:end) = angle(2:end);                 % Create random finger motion in degree with the given range of mobilities
devAngle = segConfig0';
jointAngvec = jointAngvec + devAngle;              % Tranform degree to radius and shift the angle with the deviation. Dimension: 3xk
angle = angle + devAngle(end);

%% Update
for i = 1:k
    [seg_truth(i,:), IMU_truth(i,:)] = configUpdate_OS(placement_quat, jointAngvec(:,i), frameNum);
end

%% Deviation from the global frame
for i = 1:k
    for j = 1:frameNum
        seg_truth(i,j) = segOrient0_quat * seg_truth(i,j) * segOrient0_quat.inv;
        jointAngvec(:,i) = segOrient0_quat * jointAngvec(:,i);
        IMU_truth(i,j) = segOrient0_quat * IMU_truth(i,j) * segOrient0_quat.inv;
    end
end