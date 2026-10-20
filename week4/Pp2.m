D = 1.5/100; 
ST = 3/100; 
SL = 3.5/100; 
V = 5; 
Ti = 20+273.15; 
Ts = 100+273.15; 
To = 70+273.15; 
Tev = (Ti+To)/2; 
rho = 1.11; 
nu = 1.74e-5; 
k = 0.0277; 
cp = 1007; 
Pr = 0.7016; 
rhos = 0.947; 
nus = 2.297e-5; 
ks = 0.03162; 
cps = 1011; 
Prs = 0.6955; 

%test that is SD larger (required for staggered setup.) 

SD = (SL^2+(ST/2)^2)^(1/2); 
test = (ST+D)/2; 

%since SD is larger we use the following eqution for Vmax 
Vmax = (ST*V)/(ST-D); 

Re = Vmax*D/nu;
C1 = 0.35*(ST/SL)^(1/5); 
m = 0.6; 
Nu = C1*Re^m*Pr^0.36*(Pr/Prs)^(1/4);
h = Nu*k/D;


syms row
eq = exp(-row*(pi*D*h)/(rho*V*ST*cp))-((Ts-To)/(Ts-Ti)); 
an = solve(eq,row);
disp(Vmax)
disp(SD)
disp(Re)
disp(Nu)
disp(h)
disp(vpa(an))





