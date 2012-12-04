close all
clear all
clc

global cost
global Dj
global alpha
global a
global U0
global Aj
global theta
global choice
global temppower
global windfarm

%% Turbine and simulation parameters

Dj = 40;
Aj = pi*Dj^2/4;
alpha = 0.09436;
a = 0.326795;
U0 = 12;
choice = 1;

load('C:\Users\Prasad\Documents\MATLAB\UWFLO\ITHS Data\hdata3.mat','z');
windfarm = z;
x = z(:,2);
y = z(:,1);
M = numel(z(:,1));
cost = M*((2/3)+((1/3)*exp((-0.00174)*(M^2)))); % cost estimation,
tflag=1;
[lmicro umicro] = boundary(x,y);

for theta = deg2rad(10):deg2rad(10):deg2rad(360)
OldPower(tflag,1) = pwrgen_micro(z);
temppower = OldPower(tflag,1);
windfarm = z;
OldEff(tflag,1) = OldPower(tflag,1)/(M*518.4);
[D D1 D2 D3 D4] = ITHS(2*M,lmicro,umicro,@microopt);
[xmicro ymicro] = microlayout(D3,M);
zmicro = [xmicro' ymicro'];
% NewPower1(tflag,1) = (1+summov)/D4;
NewPower(tflag,1) = pwrgen_micro(zmicro);
Powerinc(tflag,1) = NewPower(tflag,1) - OldPower(tflag,1);
NewEff(tflag,1) = NewPower(tflag)/(M*518.4);
Effinc(tflag,1) = NewEff(tflag,1) - OldEff(tflag,1);
Increasepower(tflag,1) = 100*Powerinc(tflag,1)/OldPower(tflag,1);
Increaseefficiency(tflag,1) = 100*Effinc(tflag,1)/OldEff(tflag,1);
tflag=tflag+1;
end



