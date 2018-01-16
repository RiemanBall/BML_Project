% Input:
%   k: total time steps
%   degreeRange: the limitation of joints (degree)
% Output:
%   rotAngel: rotation angle (degree)

function rotAngle = randMotion_OS(k, degreeRange)

%% Random raw motion
traj = zeros(1,k);
traj(101:end) = randn(1,k-100) * degreeRange;

% figure(1)
% plot(1:k, traj);

%% Low pass filter
% Fpass = 3;
% Fstop = 4;
% Ap = 1;
% Ast = 10;
% Fs = 100;
% 
% LPF = designfilt('lowpassfir','PassbandFrequency',Fpass, 'StopbandFrequency',Fstop,'PassbandRipple',...
%     Ap,'StopbandAttenuation',Ast, 'SampleRate',Fs, 'DesignMethod', 'kaiserwin');

% hfvt = fvtool(LPF);
% N = filtord(LPF);

%% Smoothen the motion
% jointAngle = filter(LPF,traj);
% figure(2)
% plot(1:k, rotAngle);

jointAngle = smoothdata(traj, 'gaussian', 100);
rotAngle = jointAngle;

% figure(3)
% plot(1:k, jointAngle);
