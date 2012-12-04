function f = rotation(psi)

f = [1 0 0;0 -1 0;0 0 -1]*[cos(psi) -sin(psi) 0; %Earth Fixed Frame
     sin(psi)  cos(psi) 0;
     0         0        1];
%  f= eye(3);                  %Vessel parallel co-ordinates
end