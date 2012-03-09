close all;
clear globalvariable;
clear;
clc;

global cost
global Dj
global alpha
global a
global U0
global Aj
global newpower

%% Turbine parameters
U0=12;
Dj = 40;
Aj = pi*Dj^2/4;
alpha = 0.09436;
a = 0.326795;

%% Main program
M = input('Enter number of turbines: ');
tic;
o=1;
% for o=1:1:10 %number of runs
lb = ones(1, M);
ub = 100*ones(1,M);
cost = M*((2/3)+((1/3)*exp((-0.00174)*(M^2))));
[C C1 C2 C3 C4] = ITHS(M,lb,ub,@uwflo);
Totalpower = (cost)/C4;
Farmeffeciency = Totalpower/(M*518.4);
[x y]=layout(C3,M);
z=[x y];
z=sortrows(z,[2 1]);

%% Micro-sitting
[lmicro umicro] = boundary(x,y);
[D D1 D2 D3 D4] = ITHS(2*M,lmicro,umicro,@micro);
[xmicro ymicro] = microlayout(D3,M);
NewPower = newpower;
NewFarmEffeciency = NewPower/(M*518.4);
IncreaseEffeciency = 100*(NewPower - Totalpower)/Totalpower;
znew = [xmicro' ymicro'];
znew = sortrows(znew,[2,1]);

filename = ['hdata' num2str(o) '.mat'];
save(filename);
% end
disp('Done');
beep;
time=toc/o;
