% file MyFirstPlots.m starts → first declare some font settings
set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',15)

clear *
Nx = 100; 
Nxtot = Nx +2; 
Ny = 100;
Nytot = Ny +2; 
Lx = 2*pi; 
Ly = 2*pi; 
dx = Lx/Nx; 
dy = Ly/Ny; 

yc= Ly/2; 
xc = Lx/2; 
sigx = Lx/10; 
sigy = Ly/10; 
Tref = 300; 
Ta = 100; 
alpha =1.1e-4; 

% define x and y 
x = linspace(dx/2, Lx-dx/2, Nx); 
y = linspace(dy/2, Ly-dy/2, Ny); 

%2d grids need meshgrid commands
[X,Y]= meshgrid(x,y); 

To = Tref + Ta * exp(-((X-xc).^2)/(2*sigx^2)-(Y-yc).^2/(2*sigy^2)); 

%indexes to avoid for loops 
inx = 2:(Nxtot-1); iny = 2:(Nytot-1); east = inx+1; west = inx-1;
north = iny+1; south = iny-1;

T = zeros(Nytot, Nxtot);
T(iny,inx) = To; 

%simulation params
simutime = 1000; 
dt = 0.0001; 
steps = round(simutime/dt); 
plotfreq = 100; 

for t = 1 : steps
   
setBCs; 
computeDerivatives; 

dT = alpha * dt * (Txx + Tyy); 
T(iny,inx) = T(iny,inx) + dT;

if(mod(t,plotfreq)==0)
        figure(1), clf
        surf(X,Y, T(iny,inx)), view(0,0)
        title('Temperature distribution at t= 1 s')
        xlabel('Length (m)')
        ylabel('Temperature (K)')
        xlim([0 Lx]) 
        ylim([0 Ly])
        zlim([300 400])
        pause(0.01)
end 

end 






