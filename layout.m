function [x y] = layout(k,n)
% k = floor(k);
l = gridnumber(k);
x = zeros(n,1);
y = zeros(n,1);
    for j=1:1:n;
    x(j)=l(j,2);
    y(j)=l(j,1);
    end
%     plot(x,y,'b*');grid ON; rotate3d on
    