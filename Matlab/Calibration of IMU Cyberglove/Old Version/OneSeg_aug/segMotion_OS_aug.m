% Initialize the orientation of the finger and the true orientation of the
% IMUs in terms of quaternion.
% Assume the rotation axis is in negative x-axis direction.

function [placement_angvec, jointAngvec, rotAngle, devAngle, IMU_truth, seg_truth] = segMotion_OS_aug(k, sensorNum, stdDev_Config0, stdDev_Placement0)

%% Initialization
seg_truth = repmat(Quaternion(),k,1);   % For now, the segment is perfectly straight and along with the global frame.
IMU_truth = seg_truth;                  % For now, the IMUs are perfectly aligned with the finger.

%% Set the initial configureation of the finger
% Random deviation from the straight configuration in rad unit. In this
% case, we assume the rotation axis is in negative x-axis direction.
segConfig0 = [randn, 0, 0] * stdDev_Config0;        

%% Create random Segment motion
degreeRange = 45;                   % The range of the joint within which the segment is able to move.
rotAngle = zeros(1, k);
rotAngle(2:end) = d2r(randMotion_OS(k-1, degreeRange));     % Create a random rotation angle without deviation
devAngle = segConfig0';
rotAngle = rotAngle + devAngle(1);            % Shift the angle with the deviation.

% Create a random Segment motion in angle-axis form. We assume it is align with the negative x-axis of its parent segment
jointAngvec = zeros(3, k);
jointAngvec(1, :) = -rotAngle;

%% Set the deviation of the IMU from its parent frame
placement = randn(sensorNum, 3) * stdDev_Placement0;        % Misplacement with rotation angles w.r.t x-, y-, and z-axis of each sensor's parent joint frame.
placement_quat = r2q(placement);                            % 1x2 Quaternion
placement_angvec = rotAngle2angvec(placement);              % 2x3

%% Change the base coordinate of jointAngvec from its parent segment to the
%  global frame and quaternion format.
joint_quat = repmat(Quaternion, k, 1);
for i = 1:k
    joint_quat(i) = placement_quat(1).inv * angvec2q(jointAngvec(:, i)) * placement_quat(1);
    jointAngvec(:,i) = q2angvec(joint_quat(i));
end

%% Update
for i = 1:k
    [seg_truth(i,:), IMU_truth(i,:)] = configUpdate_OS(placement_quat, joint_quat(i));
end

% %% Deviation from the global frame
% for i = 1:k
%     for j = 1:frameNum
%         seg_truth(i,j) = segOrient0_quat * seg_truth(i,j) * segOrient0_quat.inv;
%         jointAngvec(:,i) = segOrient0_quat * jointAngvec(:,i);
%         IMU_truth(i,j) = segOrient0_quat * IMU_truth(i,j) * segOrient0_quat.inv;
%     end
% end