Ts = 150 +273.15; 
Tinf = 20 + 273.15; 
H = 0.8; 
w = 1.1; 
A = H* w; 
alpha = 3.086e-5; 
Pr = 0.7132; 
cp = 1008; 
k = 0.03024; 
nu = 2.201e-5; 
Tavg = (Ts+Tinf)/2;
Ra = 9.81 * (1 / Tavg) * (Ts - Tinf) * H^3 / (nu * alpha);
Nu = (0.825  + (0.387 * Ra^(1/6))/(1+(0.492/Pr)^(9/16))^(8/27))^2;
h = Nu * k / H;
Q = h * A * (Ts - Tinf);
disp(Q)


%b) 

eps = 0.9; 
sigma = 5.670374419e-8; 
qq = eps * sigma * A*(Ts^4-Tinf^4); 
disp(vpa(qq))








