clear;
clc;
close all;

%% Offline set - Load IMU data
% load('dataVideo1');
% y = dataVideo1;
% [k, sensorNum] = size(y);       % k is the time index
% sensorNum = sensorNum/4;

%% Simulation
% Initialization of Simulation
T = 10;        % Simulate 10 second
stillTime = 1;     % The time when the hand doesn't move
rate = 100;     % Sampling rate = 100 Hz
k = T*rate;     % Time index
stillK = stillTime * rate;
pLength_const = [5, 3, 1];            % Set the length of the user's phalanges
sensorNum = 3;
% handDOF = [2 1 1];                    % The proximal joint has 2 DOF
frameNum = 3;
constStateNum = sensorNum*3;
TVStateNum = frameNum*3;
stateNum = constStateNum + TVStateNum;          % In our case, 9 const IMU orientation states, 4 time-varying rotation angle states.

%% Create hand motion and ground-truth measurement
stdDev_Config0 = d2r(3);
var_Config0 = stdDev_Config0^2;
stdDev_Orient0 = d2r(3);
var_Orient0 = stdDev_Orient0^2;
stdDev_Placement0 = d2r(3);
var_Placement0 = stdDev_Placement0^2;

[placement_angvec, placement, fingerMoveAngvec, fingerMoveAngleMatrix, IMU_truth, finger_truth] = handMotion(k, frameNum, TVStateNum, stdDev_Config0, stdDev_Orient0, stdDev_Placement0);
RP = placement_angvec';

%% Hand motion animation
% motionPlot(finger_truth, IMU_truth, pLength_const)

%% Measurement
bias_measurement = d2r(0);
stdDev_measurement = d2r(0);
var_measurement = stdDev_measurement^2;
IMUOutput = measurement(IMU_truth, bias_measurement, stdDev_measurement);
rLength = 3*frameNum;

%% Initialization of the estimate
deviation0 = repmat([1,0,0,0],sensorNum,1);
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlcon = @nonlinearCon;
options = optimoptions(@fmincon,'Display','iter');
options.MaxFunctionEvaluations = 30000;

costFunh = @(x)costFun_IMU(x, IMUOutput);
deviation = fmincon(costFunh, deviation0, A, b, Aeq, beq, lb, ub, nonlcon, options);
deviation0 = deviation;


%% Transform to the angle axis representation
qd = repmat(Quaternion(), 1, sensorNum);
for i = 1:sensorNum
    qd(i) = Quaternion(deviation(i,:));
end

constStateEst = zeros(3,3);
for i = 1:sensorNum
    constStateEst(i,:) = q2angvec(qd(i));
end

%% Test qd with visualization
q_placement = r2q(placement);
initialFrame = Quaternion;

for i = 1:sensorNum
    figure(i)
    qd(i).plot('color','r');                % Estimated deviation
    hold on;
    q_placement(i).plot('color','b');       % True deviation
    initialFrame.plot('color','k');          % The frame of the corresponding finger joint is the initial frame 
end

%% Test q0s with visualization
% for i = 1:k
%     for j = 1:sensorNum
%         hold off;
%         figure(j);
%         q1 = finger_truth(i,j) * qd(j);
%         hold on;
%         q2 = IMUOutput(i,j);
%         q1.plot('color','r');
%         q2.plot('color','b');
%     end
% end