<<<<<<< HEAD
function [f,f1] = pwr(wf,x)
=======
function [f,f1] = pwr(wf)
>>>>>>> origin/master

%% Global variables initialisation
global windfarm
global Dj
% global cost
global alpha
global U0
global theta
<<<<<<< HEAD
global micro
=======
>>>>>>> origin/master


%% Variables
% theta = 3.14; %Angle of wind
<<<<<<< HEAD

if x == 1
N = numel(wf); % Number of turbines
cost = N*((2/3)+((1/3)*exp((-0.00174)*(N^2))));
=======
C = numel(wf);
cost = C*((2/3)+((1/3)*exp((-0.00174)*(C^2))));
N = numel(wf); % Number of turbines
>>>>>>> origin/master
M = zeros(N,N);
chk = zeros(N-1,N);
power = zeros(1,N);

%% Wind Farm co-ordinate
coord = gridnumber(wf); %grid co-ordinates of turbines
Yi = coord(:,1);
Xi = coord(:,2);
x = cos(theta)*Xi - sin(theta)*Yi;
y = sin(theta)*Xi + cos(theta)*Yi;
windfarm = [x y];

%% Wake matrix
for i = 1:1:N-1
    for j = i+1:1:N
deltax = x(i) - x(j);
deltay = y(i) - y(j); %#ok<*IJCL>

if abs(deltax) < 199 && abs(deltay) < 199 == 1
   chk(i,j) = 1; %Grid Check
else
   chk(i,j) = 0;
end

Dwake = Dj + 2*alpha* deltax;

if (deltax > 0 && abs(deltay)-Dj/2 < Dwake/2)
    M(i,j) = 1;   %Wake Matrix
    M(j,i) = -1;   %Wake Matrix
else
    M(i,j) = 0;
end
     end
end

%% Power Generation calculation
for l = 1:1:N
    r = find(M(:,l)>0);
    s = find(chk(:,l)>0, 1);
    if isempty(s) == 0
        U = 0;
    else
    if isempty(r) == 1
        U = U0;
    else
        U = calcvel(r,l);
    end
    end
    
     power(l) = 0.3*(U^3);
end

%% Objective function
    totalpower = sum(power);
    f1 = cost/totalpower;
    f = totalpower;
<<<<<<< HEAD
    
elseif x == 2
%% Variables
% theta = 3.14; %Angle of wind
N = numel(wf)/2; % Number of turbines
cost = N*((2/3)+((1/3)*exp((-0.00174)*(N^2))));
M = zeros(N,N);
power = zeros(1,N);
chk = zeros(N-1,N);
micro = zeros(N,2);

%% Micro sitting co-ordinates
for i = 1:1:N 
    
    j = (2 * i) - 1; 
    micro(i,1) = wf(j); 
    micro(i,2) = wf(j+1); 
     
end 

% micro = sortrows(micro,[2 1]);
Yi = micro(:,1);
Xi = micro(:,2);
x = cos(theta)*Xi - sin(theta)*Yi;
y = sin(theta)*Xi + cos(theta)*Yi;
micro = [x y];

%% Wake matrix
for i = 1:1:N-1
    for j = i+1:1:N
deltax = x(i) - x(j);
deltay = y(i) - y(j); %#ok<*IJCL>

if abs(deltax) < 199 && abs(deltay) < 199 == 1
   chk(i,j) = 1; %Grid Check
else
   chk(i,j) = 0;
end

Dwake = Dj + 2*alpha* deltax;

if (deltax > 0 && abs(deltay)-Dj/2 < Dwake/2)
    M(i,j) = 1;   %Wake Matrix
    M(j,i) = -1;   %Wake Matrix
else
    M(i,j) = 0;
end
     end
end

%% Power Generation calculation
for l = 1:1:N
    r = find(M(:,l)>0);
    s = find(chk(:,l)>0, 1);
    if isempty(s) == 0
        U = 0;
    else
    if isempty(r) == 1
        U = U0;
    else
        U = calcvel_micro(r,l);
    end
    end
    
     power(l) = 0.3*(U^3);
end


%% Objective function
    totalpower = sum(power);
    f1 = cost/totalpower;
    f = totalpower;
end
=======
end
>>>>>>> origin/master
