function [x y] = microlayout(k,n)
i=1;
x = zeros(1,n);
y = zeros(1,n);
for j=1:1:n;
    x(j)=k(1,i);
    y(j)=k(1,i+1);
    i=i+2;
end
end