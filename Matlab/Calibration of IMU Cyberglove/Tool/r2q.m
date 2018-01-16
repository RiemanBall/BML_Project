% The rotation matrix is defined by performing the rotation w.r.t x-, y-, and z-axis in sequence, i.e (roll, pitch, yaw angles)
% Transform the rotation matrix to quaternion

function quat = r2q(rotAngleMatrix)

if size(rotAngleMatrix,2) ~= 3
    rotAngleMatrix = rotAngleMatrix';
end

sensorNum = size(rotAngleMatrix,1);
quat = repmat(Quaternion(),1,sensorNum);

for i = 1:sensorNum
    R = rotz(rotAngleMatrix(i,3))*roty(rotAngleMatrix(i,2))*rotx(rotAngleMatrix(i,1));        
    quat(i) = Quaternion(R);
end