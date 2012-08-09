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
global choice
global winddata

%% Turbine parameters

Dj = 40;
Aj = pi*Dj^2/4;
alpha = 0.09436;
a = 0.326795;
choice = 1;
M = input('Enter number of turbines: ');

for o=1:2 %number of runs
if (choice == 3)
    m = 1000;
n = 4;

p = [0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.011 0.021 0.9650;...
    0.003 0.013 0.028 0.956;...
    0.003 0.015 0.032 0.950;...
    0.003 0.018 0.038 0.941;...
    0.003 0.017 0.049 0.931;...
    0.003 0.022 0.061 0.914;...
    0.003 0.017 0.049 0.931;...
    0.003 0.018 0.038 0.941;...
    0.003 0.015 0.032 0.950;...
    0.003 0.013 0.028 0.956];

uni = rand(length(p),m);

cumprob = zeros(length(p),n+1);
for i = 1:length(p)
cumprob(i,:) = [0 cumsum(p(i,:))];
end

winddata = zeros(length(p),m);

for i = 1:length(p)
for j = 1:n
  ind = (uni(i,:)>cumprob(i,j)) & (uni(i,:)<=cumprob(i,j+1));
  winddata(i,ind) = j;
  if winddata(i,ind)== 1
      winddata(i,ind) = 8;
  elseif winddata(i,ind) == 2
          winddata(i,ind) = 12;
  elseif winddata(i,ind) == 3
      winddata(i,ind) = 17;
  elseif winddata(i,ind) == 4;
      winddata(i,ind) = 0;
  end
end
end
else
    U0 = 12;
end
%% Main program

tic;
lb = ones(1, M);
ub = 100*ones(1,M);
cost = M*((2/3)+((1/3)*exp((-0.00174)*(M^2))));
[C C1 C2 C3 C4] = modIths(M,lb,ub,@uwflo);
Totalpower = (cost)/C4;
Farmeffeciency = Totalpower/(M*518.4);
[x y]=layout(C3,M);
z=[x y];
z=sortrows(z,[2 1]);

%% Micro-sitting
% [lmicro umicro] = boundary(x,y);
% [D D1 D2 D3 D4] = ITHS(2*M,lmicro,umicro,@micro);
% [xmicro ymicro] = microlayout(D3,M);
% NewPower = newpower;
% NewFarmEffeciency = NewPower/(M*518.4);
% IncreaseEffeciency = 100*(NewPower - Totalpower)/Totalpower;
% znew = [xmicro' ymicro'];
% znew = sortrows(znew,[2,1]);

filename = ['hdata' num2str(o) '.mat'];
save(filename);
end
disp('Done');
beep;
time=toc;
