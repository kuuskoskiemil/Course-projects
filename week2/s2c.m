
clear *
alpha = 1.1e-4;
Tvasen = 300; 
Toikea = 300; 
L = 3/100; 
N = 100; 
Ntot = N+2;
dx = L/N; 
Tstart = 300;
x = linspace(dx/2, L-dx/2, N); 

T = zeros(1,Ntot); 
x_full = [0 x L];
        
q_rand = 1000 + 1000*rand; 

in = 2:(Ntot-1); 
next = in+1; 
prev = in-1; 
T(in) = Toikea;
simutime = 100; 
dt = 0.0001; 
steps = round(simutime/dt); 
plotfreq = 100; 

times = [0.01/dt, 0.2/dt, 1/dt];

k  = 390 ; 


for t = 1 : steps 
    T(1) = T(2); 
    T(Ntot) = T(Ntot-1) + dx * q_rand/k; 
    d2Tdx2 = (T(next)-2*T(in)+T(prev))/(dx^2);
    dT = alpha * dt * d2Tdx2; 
    T(in) = T(in)+dT;

    if ismember(t, times)
        plot(x_full, T,LineWidth=2)
        hold on 
    
    end 
end 

title('Temperature distribution at certain time steps')
legend('t = 0.01 s', 't = 0.2 s', 't = 1 s')
xlabel('Length (m)')
ylabel('Temperature (K)')



