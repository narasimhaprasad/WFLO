%% Dynamic Matrices
global Vc;

MA = [2.5 0 0;
    0 2.5 0
    0 2.5 0.04683];
MRB =[1.65 0 0;
    0 1.98 -1.22e-04;
    0 -3.8933e-05 1.75e-02];
D = [6.5541e-04 0 0;0 7.1768e-04 -6.3413E-08;0 -2.1033E-08 -2.6495E-10];
b = [1;1;1];
psiinitial= rotation(0);
B = 20/100;
L = 30/100;
T = 5/100;


Vmax=3;
Vmin=0.1;
Vc=0.5*(Vmax+Vmin);


set(0,'ShowHiddenHandles','On')
set(gcf,'menubar','figure')

