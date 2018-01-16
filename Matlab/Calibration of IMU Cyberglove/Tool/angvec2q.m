% The rotation matrix is defined by performing the global rotation w.r.t 
% x-, y-, and z-axis in sequence, i.e (roll, pitch, yaw angles)
% Transform the quaternion to angle-axis representation.
% Input:
%   angvec: a cluster of angle-axis vectors.
%   tolerance: 
%   angvecNum: the number of the angle-axis vectors
% Output:
%   quat: a quaternion corresponds to angvec.

function  quat = angvec2q(angvec, tolerance)

if size(angvec,1) > size(angvec,2)
    angvec = angvec';
end

if nargin == 1
    tolerance = 1e-3;
end

angvecNum = length(angvec)/3;

if angvecNum == 1
    alpha = norm(angvec);
    if abs(alpha) < tolerance
        S = 1/2 - alpha^2/48;
    else
        S = sin(alpha/2)/alpha;
    end
    quat = Quaternion([cos(alpha/2), angvec * S]);

else
    quat = repmat(Quaternion(), 1, angvecNum);

    for i = 1: angvecNum
        x = angvec( 3*i-2 : 3*i );

        alpha = norm(x);         % Rotation angle of the angle-axis vector

        if abs(alpha) < tolerance
            S = 1/2 - alpha^2/48;
        else
            S = sin(alpha/2)/alpha;
        end

        quat(i) = Quaternion([cos(alpha/2), x*S]);
    end
end