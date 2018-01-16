% Jocabian of the residual

% J: the Jocabian of the residual with dimension equal to 
% (3*sensorNum X stateNum)

function J = jacob_OS_stage2(r, x_est, measurement)

n = length(r);                                  % n = 3 * frameNum
varNum = length(x_est);
tol = 1e-3;
x_s1 = x_est(1:3);
x_j1 = x_est(4:end);
IMUPlacementEst = angvec2q(x_s1, tol, 1);
segOrientEst = angvec2q(x_j1, tol, 1);

% J(i,j) = dri_duj * duj_dxj   for i >= j
J = zeros(n, varNum);
dr_du_s1 = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
dr_du_j1 = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
q_diag = [Quaternion(), Quaternion([0 -1 0 0]), Quaternion([0 0 -1 0]), Quaternion([0 0 0-1])];


for i = 1:4
    %% IMU Placement
    temp = q_diag(i) / segOrientEst * measurement;
    dr_du_s1(:, i) = 2 * temp.v';
    
    %% Segment Orientation
    temp = IMUPlacementEst.inv * q_diag(i) * measurement;
    dr_du_j1(:, i) = 2 * temp.v';
end
    
%% IMU Placement
alpha = norm(x_s1);
if alpha < tol
    S = 1/2 - alpha^2/48;
    C = -1/24 + alpha/960;
else
    S = sin(alpha/2)/alpha;
    C = (cos(alpha/2)/2 - S)/alpha^2;
end

du_dx = [-S / 2 * x_s1' ; C * (x_s1 * x_s1') + S * eye(length(x_s1))];
J(:, 1:3) = dr_du_s1 * du_dx;

%% Segment Orientation
alpha = norm(x_j1);
if alpha < tol
    S = 1/2 - alpha^2/48;
    C = -1/24 + alpha/960;
else
    S = sin(alpha/2)/alpha;
    C = (cos(alpha/2)/2 - S)/alpha^2;
end

du_dx = [-S / 2 * x_j1' ; C * (x_j1 * x_j1') + S * eye(length(x_j1))];
J(:, 4:end) = dr_du_j1 * du_dx;
