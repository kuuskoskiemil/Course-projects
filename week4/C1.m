clear *

Lx = 0.1; 
Ly = 0.004; 
Nx = 50; 
Ny = 50; 
Nxtot = Nx+2; 
Nytot = Ny+2; 
Ntot = 52; 
alpha = 1.5e-7; 
nu = 8.9e-7; 
L = Ly/2; 
dx = Lx/Nx; 
dy = Ly/Ny; 
Pr = nu/alpha; 
cp = 4190; 
rho = 1000; 
k = cp*rho * alpha; 
Ts = 303; 

%i guess this is water. 



Umax =0.03;
x = linspace(dx/2,Lx-dx/2,Nx); 
y = linspace(dy/2,Ly-dy/2, Ny); 
Re = (Umax*L)/nu; 
xt = 0.05 * Re*Pr*Ly;

%meshgrid; 
[X,Y] = meshgrid(x,y); 


%calculate U 
Ux = 4/Ly^2*Umax * (Ly*Y-Y.^2); 
Uy = 0; 

inx = 2:(Nxtot-1); iny = 2:(Nytot-1);
east = inx+1; west = inx-1;
north = iny+1; south = iny-1;
T=293*ones(Nytot,Nxtot);

Simutime=220; %sekunteja
dt = 0.005;
steps=round(Simutime/dt);
plotfreq=100;




%local heattransfercoef. 


for t = 1:steps 

T(iny,Nxtot)=T(iny,Nxtot-1);
T(iny,1) = 2*293-T(iny,2); 

T(Nytot, inx) = 2*303-T(Nytot-1,inx); 
T(1, inx) = 2*303-T(2,inx);


compute_derivatives;

dT = (alpha .*(Txx+Tyy)-Ux.*Tx).*dt; 
T(iny,inx) = T(iny,inx) + dT; 

end
figure(1)
Tm = sum(T(iny,inx).*Ux)./(sum(Ux));
plot(x,Tm, LineWidth=2,Color='r')
ylim([292.5 303.5])
yline(293,color='g') 
yline(303,color='b')
title('cup-mean temperature (K)')
legend('Cup-mean temperature(K)', '293K','303K')

xlabel('x(m)')
ylabel('Temperature (K)')

%c) 
dTdy = (T(1,inx)-T(2,inx))/dy; 
qwall = k * dTdy; 
h = qwall./(Ts-Tm); 
Nusselt = 2*Ly*h/k; 
Nusselt_approx = 7.52; 
x_therentry = 0.05*Re*Pr*Ly;

figure(2)
imagesc(T(iny,inx))
title('2D heat conduction steady state (U_max = 0.03, graph time = 220s)')
xlabel('x')
ylabel('y')
zlabel('Temperature(K)')


figure(3)
plot(x,Nusselt) 
yline(Nusselt_approx,LineWidth=2,Color='r')
xline(x_therentry,LineWidth=2,Color='g')
legend('Nusselts number','Approximation (7.52)','thermal entry length')
title('Nusselts number')









