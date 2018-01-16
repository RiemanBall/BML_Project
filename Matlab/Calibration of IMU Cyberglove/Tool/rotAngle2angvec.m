% Transform the rotation angle in Roll, Pitch, Yaw form to angle-axis
% representation
% Input:
%   angle: a kx3 matrix. Each row is a roll, pitch, yaw vector.
% Output:
%   x: a kx3 matrxi. Each row is the corresponding angle-axis
%       representation = alpha*v, where alpha is the rotation angle, and v
%       is the unit rotation axis.

function x = rotAngle2angvec(angle, tolerance)

if nargin == 1
    tolerance = 0.001;
end

[k,l] = size(angle);

% Make sure the size is kx3
if l ~= 3
    angle = angle';
    temp = k;
    k = l;
    l = temp;
end

x = zeros(k,l);

for i = 1:k
    x(i, 1:3) = q2angvec(r2q(angle(i,:)), tolerance);
end