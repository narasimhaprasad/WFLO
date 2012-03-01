close all
clear
clc



global Dj
global alpha
global a
global U0
global Aj
global theta
% global newpower
global f1

grid = load('Gradycasebgrid','grid');
k = 1;
M = numel(grid.grid);
coord = gridnumber(grid.grid);
Y = coord(:,1);
X = coord(:,2);
[lmicro umicro] = boundary(X,Y);
U0=12;
Dj = 40;
Aj = pi*Dj^2/4;
alpha = 0.09436;
a = 0.326795;

for theta = 0.628:0.628:10*0.628
    [f1(k,1),f(k,1)] = pwr(grid.grid);
    t(k,1) = theta;
    k = k+1;
end

%%
theta = 1*0.628;
[D D1 D2 D3 D4] = ITHS(2*M,lmicro,umicro,@micro);
[xmicro ymicro] = microlayout(D3,M);
NewPower = (1-D4)/D4;
delnp = f1(5)-NewPower;
znew = [xmicro' ymicro'];
% znew = sortrows(znew,[2,1]);