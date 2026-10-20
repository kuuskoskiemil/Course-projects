% file DifferentiateFunction.m starts → first declare some font settings
set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',15)
clear *
N = 50; % N internal grid points
Ntot = N+2; % total number of grid points including boundary "ghost cells"
L = 2*pi; % length of domain in meters 0<= x <= L
dx = L/N;
xc = L/2; 
sigma = L/10;

x = linspace(dx/2, L-dx/2, N); % 1st cell at dx/2,2nd cell at 3dx/2, Nth at L-dx/2
To = exp(-(x-xc).^2/(2*sigma^2)); % now To has N temperature values

T = [To(1) To To(N)];

in = 2:(Ntot-1);
east = in+1; west = in-1; 

Simutime = 20; 
dt = 0.001;
steps = round(Simutime/dt);
alpha = 1;
plotfreq = 100; 
for t = 1: steps
    T(1) = T(2) ;
    T(Ntot) = T(Ntot-1);
    d2Tdx2 = (T(east)-2*T(in)+T(west))/(dx^2);
    dT = alpha * dt*d2Tdx2;
    T(in) = T(in)+dT; %you only update the inner values not the boundaries
    if (mod(t,plotfreq)==0)
        figure(1), clf
        plot(x,T(in), "LineWidth",2)
        xlim([0 L])
        ylim([0 0.5])
        pause(0.01)
    end
end





