function v = motionPlot(pLength, finger, IMU)

k = length(finger);     % Time
frameNum = length(finger(1).orient);
jointPos = zeros(4,3);
totalLength = sum(pLength);
animation(k) = struct('cdata',[],'colormap',[]);
screenSize = get(0, 'ScreenSize');


for t = 1:k
    clf
    plot3(0,0,0,'r.', 'MarkerSize', 40);
    set(gcf, 'Position', screenSize);
    for i = 1:frameNum
        if nargin == 3
            IMUPos = quatPlot(jointPos(i,:), pLength(i)/2, finger(t).orient(i));
            quatPlot(IMUPos, 0, IMU(t).orient(i), 'g.');
        end
            jointPos(i+1,:) = quatPlot(jointPos(i,:), pLength(i), finger(t).orient(i));
    end
    axis([-totalLength,totalLength,-totalLength,totalLength,-totalLength,totalLength])
    view(-45,45)
    drawnow
    animation(t) = getframe;
end


v = VideoWriter('motion.avi');
open(v)
writeVideo(v,animation)
