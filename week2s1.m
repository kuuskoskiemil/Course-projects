% file DifferentiateFunction.m starts → first declare some font settings
set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',15)
clear *
clf
Ta = 20 ; 
T0 = 293; 
xc = 4; 
sigma = sqrt(2);
L = 8; 
N = 500; 
Ntot = N+2;
dx = L/N; 
x = linspace(dx/2, L-dx/2, N);
To = Ta*exp(-((x-xc).^2)/(sigma^2))+T0;
T = [To(1) To To(N)];

index = 2:(Ntot-1);
next = index +1; 
prev = index-1; 


dTdx= (T(next)-T(prev))/(2.*dx);
dT = [dTdx(1) dTdx dTdx(N)];
dTdx_analytical = 20*(4-x).*exp(-((x-4).^2/(2)));
size(x) 
size(dTdx)
d2Tdx = (dT(next)-dT(prev))/(2.*dx);
d2Tdx_analytical = (20*x.^2-160*x+300).*exp(-((x-4).^2/2));
plot(x,dTdx,LineWidth=2,Color='b')
hold on 
plot(x,dTdx_analytical,'r--',LineWidth=2)
hold on 
plot(x,d2Tdx,LineWidth=2,color='r')
hold on 
plot(x,d2Tdx_analytical,'g--',LineWidth=2)
legend('dTdx numerical','dTdx analytical','d2Tdx^2 numerical', 'd2Tdx^2 analytical')
xlabel('length (x)')
ylabel('Derivative value')














