% Input:
%   k: total time steps
%   degreeRange: the limitation of joints (degree)
% Output:
%   rotAngel: rotation angle (degree)

function rotAngle = randMotion_OS(k, degreeRange)

%% Random raw motion
% Motion 1
stillTime = 250;
traj = zeros(1,k);
traj(stillTime+1 : end) = randn(1, k - stillTime) * degreeRange;

% Motion 2
% for i = 2 : k/stillTime
%     traj(stillTime * (i-1) + 1 : stillTime * i) = randn * degreeRange * ones(1,stillTime);
% end

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

jointAngle = smoothdata(traj, 'gaussian', 400);
rotAngle = jointAngle * 10;

% figure(3)
% plot(1:k, rotAngle);
