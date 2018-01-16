function endPos = quatPlot(startPos, length, quat, dotColor)

if nargin < 4
    dotColor = 'r.';
end

if size(startPos,1) > size(startPos,2)
    o = startPos;
else
    o = startPos';
end

hold on
plot3(startPos(1), startPos(2), startPos(3), dotColor, 'MarkerSize', 40);


scaleFactor = 3;
orient_x = quat*[1 0 0]';
orient_y = quat*[0 1 0]';
orient_z = quat*[0 0 1]';

x1 = o + orient_x/scaleFactor;
y1 = o + orient_y /scaleFactor;
z1 = o + orient_z/scaleFactor;

plot3([o(1);x1(1)], [o(2); x1(2)], [o(3); x1(3)], 'b')
text(x1(1), x1(2), x1(3), 'X')
plot3([o(1);y1(1)], [o(2); y1(2)], [o(3); y1(3)], 'b')
text(y1(1), y1(2), y1(3), 'Y')
plot3([o(1);z1(1)], [o(2); z1(2)], [o(3); z1(3)], 'b')
text(z1(1), z1(2), z1(3), 'Z')

if length ~= 0
    endPos = o + length*orient_x;
    plot3([o(1);endPos(1)], [o(2); endPos(2)], [o(3); endPos(3)], 'k');
end

axis equal
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
hold off