% Input:
%   k: total time steps
%   degreeRange: the limitation of joints (degree)
% Output:
%   rotAngel: rotation angle (degree)

function rotAngle = randMotion(k, degreeRange, TVStateNum)

%% Random raw motion
n = length(degreeRange);
% traj = cumsum(2*randn(n,k));        % Random-walk motion with the variance = 4;
traj = randn(n,k);

for i = 1:n
    if i < 3
        % Abduction and adduction
        traj(i,:) = traj(i,:)*degreeRange(i)*0.9 + degreeRange(i)/4*i;
    else
        % Flexion and extension
        traj(i,:) = traj(i,:)*degreeRange(i)*0.8 + degreeRange(i)/2;
    end
    
%     figure(i)
%     plot(1:k, traj(i,:));
end


%% Low pass filter
Fpass = 3;
Fstop = 4;
Ap = 1;
Ast = 50;
Fs = 100;

LPF = designfilt('lowpassfir','PassbandFrequency',Fpass, 'StopbandFrequency',Fstop,'PassbandRipple',...
    Ap,'StopbandAttenuation',Ast, 'SampleRate',Fs, 'DesignMethod', 'kaiserwin');

% hfvt = fvtool(LPF);
% N = filtord(LPF);

%% Smoothen the motion
movingJoint = filter(LPF,traj')';
if n > 2
    for i = 3:n
        index = movingJoint(i,:) < 0;
        movingJoint(i,index) = 0;
    end
end

rotAngle = zeros(TVStateNum, size(movingJoint,2));
rotAngle([2,3,6,9],:) = movingJoint;


% for i = 1:n
%     figure(i)
%     hold on;
%     plot(1:k, rotAngle(i,:));
% end