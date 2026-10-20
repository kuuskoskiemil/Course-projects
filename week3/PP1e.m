k = 0.6; 
H = 5/1000; 
L = 1; 
A = H * L; 
A_flow = H*H;
rho = 1000; 
u = 0.1; 
Nu = 7.54; 
Dh = 2 * H;
h = Nu * k /Dh; 
Ts = 25 + 273.15; 
Tin = 21 +273.15; 
cp = 4190; 
mdot = rho * A_flow * u;
syms Tout
eq = h * 2*A *(((Ts-Tin)-(Ts-Tout))/(log((Ts-Tin)/(Ts-Tout)))) - cp * mdot * (Tout-Tin);
solvex = vpasolve(eq,Tout)-273.15
