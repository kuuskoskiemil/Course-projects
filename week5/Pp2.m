A = 2.4;
Is = 900; 
eps = 0.1; 
alpha = 0.95; 
Ts = 100 + 273.15; 
Tsky = -10+273.15; 
epsair = 0.1; 
h = 2.5; 
Tinf = 15+273.15;
sigma = 5.670374419e-8; 

%a) 
qnet = alpha * Is*A  - A*eps * sigma * (Ts^4 - Tsky^4) - h * A * (Ts-Tinf); 
disp(vpa(qnet)/A)
%b)  efficiency
efficiency = qnet /(Is*A);
disp(vpa(efficiency))

%c) 
Tin = 15 +273.15; 
T0 = 60+273.15; 
cp_water = 4179; %at 37.5 deg c (the artihmetic avg temp) 
dT = T0-Tin; 
mflow = qnet/(dT * cp_water)*60; 
disp(mflow)
mf











