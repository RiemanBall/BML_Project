% Initialize the orientation of the finger and the true orientation of the
% IMUs in terms of quaternion.

function [placement_angvec, q_Placement, fingerMoveAngvec, fingerMoveAngleMatrix, IMU_truth, finger_truth] = handMotion(k, frameNum, TVStateNum, stdDev_Config0, stdDev_Orient0, stdDev_Placement0)

%% Initialization
finger_truth = repmat(repmat(Quaternion(),1,3),k,1);   % For now, the finger is perfectly straight and along with the global frame.
IMU_truth = finger_truth;                                      % For now, the IMUs are perfectly aligned with the finger.

%% Set the initial configureation of the finger
handConfig0 = [0 randn(1,2); 0 0 randn; 0 0 randn]*stdDev_Config0;        % Random deviation from the straight configuration in rad unit
% q_handConfig0 = r2q(handConfig0);                              % The deviation is w.r.t. the frame of the last joint (parent joint).

handOrient0 = randn(1,3)*stdDev_Orient0;                 % Random deviation of the proximal frame from the global frame
q_handOrient0 = r2q(handOrient0);

%% Set the deviation of the IMU from its parent frame
placement = randn(3,3)*stdDev_Placement0;      % Misplacement with rotation angles w.r.t x-, y-, and z-axis of each sensor's parent joint frame.
q_Placement = r2q(placement);
placement_angvec = rotAngle2angvec(placement);

%% Create random hand motion
degreeRange = [40, 70, 100, 45];                            % The range of each joint able to move. [MCP(abduction/adduction), MCP(flexion/extention), PIP(flexion/extention), DIP(flexion/extention)]
rotAngle = zeros(TVStateNum, k);
rotAngle(:, 2:end) = randMotion(k-1, degreeRange(1:frameNum+1), TVStateNum);        % Create random finger motion in degree with the given range of mobilities
devAngle = handConfig0';
devAngle = devAngle(:);
rotAngle = d2r(rotAngle) + devAngle;                                   % Tranform degree to radius and shift the angle with the deviation. Dimension: 4xk

fingerMoveAngvec = zeros(size(rotAngle));
for i = 1:k
    fingerMoveAngleMatrix = zeros(3,3);
    fingerMoveAngleMatrix(:) = rotAngle(:,i);
    fingerMoveAngvecMatrix = rotAngle2angvec(fingerMoveAngleMatrix');
    fingerMoveAngvecMatrix = fingerMoveAngvecMatrix';
    fingerMoveAngvec(:,i) = fingerMoveAngvecMatrix(:);
    %% Update
    [finger_truth(i,:), IMU_truth(i,:)] = configUpdate(q_Placement, fingerMoveAngvec(:,i), frameNum);
end


%% Deviation from the global frame
for i = 1:k
    for j = 1:frameNum
        finger_truth(i,j) = q_handOrient0*finger_truth(i,j);
        IMU_truth(i,j) = q_handOrient0*IMU_truth(i,j);
    end
end