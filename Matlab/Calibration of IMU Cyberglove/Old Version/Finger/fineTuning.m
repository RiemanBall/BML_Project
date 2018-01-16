clear
clc;
close all

% Initialization of Simulation
T = 10;        % Simulate time
stillTime = 1;     % The time when the hand doesn't move
rate = 100;     % Sampling rate = 100 Hz
k = T*rate;     % Time index
stillK = stillTime * rate;

sensorNum = 3;
frameNum = 3;
constStateNum = sensorNum*3;
TVStateNum = frameNum*3;
stateNum = constStateNum + TVStateNum;          % In our case, 9 const IMU orientation states, 4 time-varying rotation angle states.

%% Create hand motion and ground-truth measurement
stdDev_Config0 = d2r(3);
var_Config0 = stdDev_Config0^2;
stdDev_Orient0 = d2r(10);
var_Orient0 = stdDev_Orient0^2;
var_TVStates = (var_Config0 + stdDev_Orient0);
stdDev_Placement0 = d2r(10);
var_Placement0 = stdDev_Placement0^2;

[placement_angvec, q_Placement, fingerMoveAngvec, fingerMoveAngleMatrix, IMU_truth, finger_truth] = handMotion(k, frameNum, TVStateNum, stdDev_Config0, stdDev_Orient0, stdDev_Placement0);

%% Measurement
bias_measurement = d2r(0);
stdDev_measurement = d2r(0.1);
var_measurement = stdDev_measurement^2;
IMUOutput = measurement(IMU_truth, bias_measurement, stdDev_measurement);

%% Initialization of the estimate
x_est1 = zeros(stateNum, stillK);
V = var_measurement * eye(3*frameNum,3*frameNum);

%% Optimization
costFun = @(x)fineTuningCostFun(x, stillK, constStateNum, stateNum, frameNum, sensorNum, var_Placement0, var_TVStates, IMUOutput, q_Placement, V);

diagonalM0 = randn(1,18);

options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');

diagonalM = fminunc(costFun, diagonalM0, options);