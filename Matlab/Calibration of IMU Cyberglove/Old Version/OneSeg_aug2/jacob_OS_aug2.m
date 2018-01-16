% Jocabian of the residual

% J: the Jocabian of the residual with dimension equal to 
% (3*sensorNum X stateNum)

function J = jacob_OS_aug2(r, x_est, measurement, constVarNum)

n = length(r);
varNum = length(x_est);
tol = 1e-3;

x_s = x_est(1 : constVarNum);
IMUPlacementEst = angvec2q(x_s);

jointAxis = [-1,0,0]';
x_j1 = x_est(constVarNum + 1 : end) * jointAxis;
rotation = angvec2q(x_j1);

% J(i,j) = dri_duj * duj_dxj   for i >= j
J = zeros(n, varNum);
dr_du_s1 = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
dr_du_s2 = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
dr_du_j1 = zeros(3,4);           % The last 3 columns of the matrix of computed quaternions
q_diag1 = [Quaternion(), Quaternion([0 1 0 0]), Quaternion([0 0 1 0]), Quaternion([0 0 0 1])];
q_diag2 = [Quaternion(), Quaternion([0 -1 0 0]), Quaternion([0 0 -1 0]), Quaternion([0 0 0 -1])];

for i = 1:4
    %% IMU Placement1
    temp = IMUPlacementEst(2).inv / rotation * q_diag1(i) * measurement;
    dr_du_s1(:, i) = 2 * temp.v';
    
    %% Segment Orientation
    temp = IMUPlacementEst(2).inv * q_diag2(i) * IMUPlacementEst(1) * measurement;
    dr_du_j1(:, i) = 2 * temp.v';
    
    %% IMU Placement2
    temp = q_diag2(i) / rotation * IMUPlacementEst(1) * measurement;
    dr_du_s2(:, i) = 2 * temp.v';
end
    
%% IMU Placement1
x_s1 = x_s(1:3);
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

%% IMU Placement2
x_s2 = x_s(4:6);
alpha = norm(x_s2);
if alpha < tol
    S = 1/2 - alpha^2/48;
    C = -1/24 + alpha/960;
else
    S = sin(alpha/2)/alpha;
    C = (cos(alpha/2)/2 - S)/alpha^2;
end

du_dx = [-S / 2 * x_s2' ; C * (x_s2 * x_s2') + S * eye(length(x_s2))];
J(:, 4:6) = dr_du_s2 * du_dx;

%% Segment Orientation
alpha = x_est(constVarNum + 1 : end);
du_dx = [-1/2 * sin(alpha/2); 1/2 * jointAxis * cos(alpha/2)];

J(:, constVarNum + 1 : end) = dr_du_j1 * du_dx;
