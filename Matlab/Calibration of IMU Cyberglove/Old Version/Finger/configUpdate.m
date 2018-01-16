% Input:
%   IMUOrientAngle(rad or quaternion): the tilt angles/orientation of the IMU frames
%   rotAngle(rad): a 4x1 vector containing the rotation angles of MCP(abduction/adduction), MCP(flexion/extention), PIP(flexion/extention), DIP(flexion/extention)
% Output:
%   fingerOrient_new: the orientations of the joint frames after moving
%   IMUOrient_new: the orientations of the IMU frames after moving

function [fingerOrient_new, IMUOrient_new] = configUpdate(IMUPlacement, fingerMove, frameNum, tolerance)

if nargin == 3
    tolerance = 0.005;
end

%% Accept two types of input for the IMU orientation
if isa(IMUPlacement,'Quaternion')      % 1. quaternion
    IMUOrientQuat = IMUPlacement;
else                                                % 2. angle-axis representation
    IMUOrientQuat = angvec2q(IMUPlacement, tolerance, frameNum);      % Create a 1x3 quaternion vector which contains the orientations of the IMUs' deviation (const states)
end

%% Accept two types of input for the finger movement
if isa(fingerMove, 'Quaternion')
    fingerMoveQuat = fingerMove;
else
    fingerMoveQuat = angvec2q(fingerMove, tolerance, frameNum);
end

%% Update
fingerOrient_new = repmat(Quaternion(), 1, frameNum);
IMUOrient_new = repmat(Quaternion(), 1, frameNum);

for i = 1:frameNum
    if i == 1
        fingerOrient_new(i) = Quaternion() * fingerMoveQuat(i);
    else
        fingerOrient_new(i) = fingerOrient_new(i-1) * fingerMoveQuat(i);
    end
    
    IMUOrient_new(i) = fingerOrient_new(i) * IMUOrientQuat(i);
end