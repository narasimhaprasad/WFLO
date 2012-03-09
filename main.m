close all
clear
clc



global Dj
global alpha
global a
global U0
global Aj
global theta
<<<<<<< HEAD
global f1
global k
=======
% global newpower
global f1
>>>>>>> origin/master

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
<<<<<<< HEAD
% o =1;
for o = 1:1:10
for theta = 0.628:0.628:10*0.628
    [f1(k,1),f(k,1)] = pwr(grid.grid,1);
    t(k,1) = theta;
    k = k+1;
end
k = 1;
%%
for theta = 0.628:0.628:10*0.628
% theta = 5*0.628;
[D D1 D2 D3 D4] = ITHS(2*M,lmicro,umicro,@micro);
[xmicro ymicro] = microlayout(D3,M);
znew = [xmicro' ymicro'];
lay(k,:) = reshape(znew',1,[]);
NewPower(k,1) = pwr(D2,2);
Increasepower(k,1) = NewPower(k) - f1(k);
increasepercentage(k,1) = Increasepower(k)*100/f1(k);
k = k+1;
end
filename = ['microdata' num2str(o) '.mat'];
save(filename);
end
=======

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
>>>>>>> origin/master
% znew = sortrows(znew,[2,1]);