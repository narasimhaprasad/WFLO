function Vr=effoceancurrent(u,v,r,psi)
global Vc;
beta=0.523;
uc=Vc*cos(beta-psi);
vc=Vc*sin(beta-psi);
Vr=[(u-uc);(v-vc);r];
w=randn(1);
Vmax=0.7;
Vmin=0.1;
h=0.2;
Vc=Vc+(h*w);
    if(Vc>Vmax)
     Vc=Vc-(h*w);  
    end
    if(Vc<Vmin)
     Vc=Vc-(h*w);
    end