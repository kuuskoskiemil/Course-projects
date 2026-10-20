
T_b = 60 +273.15; 
T_inf = 30+273.15; 
k = 40; 
h = 50; 
t = 5/1000; 
L = 50/1000; 
D = 300/1000; 
w = 200/1000;
length = 200/1000; 
sig = (T_b-T_inf);
A_c = t * w; 
cyli_A = 2 * pi * (D/2) * w;

P = 2*(w+t); 

m = sqrt((h*P)/(k*A_c));
M = sqrt(h*P*k*A_c)*(sig);
sinhml = sinh(m*L);


q_f = M * (sinh(m*L)+(h/(m*k))*cosh(m*L))/(cosh(m*L)+(h/(m*k))*sinh(m*L));
syms N

eqn = N*q_f+h*(cyli_A-N*A_c)*(sig)-1000==0;

solvex = solve(eqn,N);
N = ceil(solvex);

A_f = (2*(t*L + L * w)+ A_c);
eta_f = q_f/(h*A_f*sig);
eps_f = q_f/(h*A_c*sig);
A_gaps = cyli_A-N*A_c;

T_fintip = T_inf + (sig)*(cosh(m*0)+(h/(m*k))*sinh(m*0))/(cosh(m*L)+(h/(m*k))*sinh(m*L));


T_bnew = (1000+T_inf*(sqrt(h*P*k*A_c)*N+h*A_gaps))/(sqrt(h*P*k*A_c)*N+h*A_gaps);


T_bn = T_inf + 1000/(N*sqrt(h*P*k*A_c)+h*A_gaps);

disp(eta_f)



