T = 293; 
Tref = 278; 
tau = 1; 

TotalSimuTime = 20;
dt = 0.1;
HowManySteps = round(TotalSimuTime/dt);

Ts = linspace(0,20,HowManySteps);
for (k=1: HowManySteps)
    dT = -(dt/tau)*(T-Tref);
    T = T+dT;
    Ts(k) = T;
end
figure(1);
plot(T,Ts)