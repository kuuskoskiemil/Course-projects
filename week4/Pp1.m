Ts = 350; 
uinf = 2; 
L = 1; 
Tinf = 300; 
Tf = 325;
rho = 1.087; 
nu = 1.8e-5; 
k = 0.0282; 
cp = 1007; 
Pr = 0.6987; 
Re = (uinf*L)/nu; 
Nu = 0.664 * Re^(1/2)*Pr^(1/3); 
h = (Nu*k)/L; 
disp(h)
qw = h * L * (Ts-Tinf);
disp(qw)
