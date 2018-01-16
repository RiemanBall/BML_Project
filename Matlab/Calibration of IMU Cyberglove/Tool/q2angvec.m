function x = q2angvec(q, tolerance)

if nargin == 1
    tolerance = 1e-4;
end

alpha = acos(q.s)*2;         % Rotation angle of the IMU orientation

if abs(alpha) < tolerance
    S = 1/2 - alpha^2/48;
else
    S = sin(alpha/2)/alpha;
end

x = (q.v/S)';               % The 1x3 angle-axis representation vector