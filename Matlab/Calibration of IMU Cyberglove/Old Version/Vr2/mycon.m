function [c,ceq] = mycon(x,frameNum)

c = 0;

for i = 1:frameNum
    c = abs(norm(x(3*(i-1)+1:3*i)) - pi) - pi/2;
    
end
ceq = [];