alpha = 1.1e-4;
Tvasen = 310; 
Toikea = 300; 
L = 3/100; 
N = 100; 
Ntot = N+2;
dx = L/N; 
Tstart = 300;
x = linspace(dx/2, L-dx/2, N); 

x_full = [0 x L];

k = 390; 
q = 1000+1000*rand; 


in = 2:(Ntot-1); 
next = in+1; 
prev = in-1; 
simutime = 100; 
dt = 0.0001; 
steps = round(simutime/dt); 
plotfreq = 100; 
T = 300 * ones(1, Ntot); 

for t = 1 : steps 
    T(1) = T(2); 
    T(Ntot) = T(Ntot-1) + dx * q/k;
    d2Tdx2 = (T(next)-2*T(in)+T(prev))/(dx^2);
    dT = alpha * dt * d2Tdx2; 
    T(in) = T(in)+dT;
    if(mod(t,plotfreq)==0)
        figure(1), clf
        plot(x_full,T,LineWidth=2)
        title('Temperature distribution at t= 1 s')
        xlabel('Length (m)')
        ylabel('Temperature (K)')
        ylim([300 301])
        pause(0.001)
    end 
end 
legend('Temperature (K)')



