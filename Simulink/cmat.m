function f = cmat(u)
m = 2.5;
CRB = [0 0 -m*u(2);0 0 m*u(1);m*u(2) -m*u(1) 0];
f = CRB;