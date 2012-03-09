function f = micro(wf)

%% Global variables initialisation
global windfarm
global Dj
global alpha
global U0
global micro
global theta
global f1
global k

%% Variables
% theta = 3.14; %Angle of wind
N = numel(wf)/2; % Number of turbines
M = zeros(N,N);
power = zeros(1,N);
chk = zeros(N-1,N);

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
    delta = (sum(power)-f1(k));
    newpower = f1(k) + delta;
    mov = abs(micro - windfarm);
    xmov = sum(mov(:,1));
    ymov = sum(mov(:,2));
    summov = xmov + ymov;
    f = 1/(newpower);
end