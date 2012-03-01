function f = uwflo(wf)

%% Global variables initialisation
global windfarm
global Dj
global cost
global alpha
global U0

%% Variables
theta = 0; %Angle of wind
N = numel(wf); % Number of turbines
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
    f = cost/totalpower;
   
end