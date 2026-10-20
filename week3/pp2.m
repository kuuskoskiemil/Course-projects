%a) 
T_in  = 60;                   % [°C]
T_out = 30;                   % [°C]
T_inf = 21;                   % [°C]
u_m   = 1.1;                  % [m/s]
D_in  = 13e-3;                % [m] converted from mm
D_out = 15e-3;                % [m] converted from mm
nu    = 6e-7;                 % [m^2/s]
k_w   = 0.63;                 % [W/m*K]
beta  = 0.421e-3;             % [1/K]
rho   = 983;                  % [kg/m^3]
c_p   = 4190;                 % [J/kg*K]
k_c   = 390;                  % [W/m*K]
g = 9.81;
T_s   = (T_in + T_out) / 2; % [°C] = 45
A_crossin = (D_in/2)^2 * pi;
Re_in = u_m*D_in/nu; 
mflow = A_crossin * rho * u_m; 
hin = c_p * T_in; 
hout = c_p * T_out; 
A_crossout = (D_out/2)^2 * pi;
Qrate = mflow * (hin-hout); 
alpha = k_w/(c_p*rho); 
Pr = nu/alpha;
Gr_out = beta * g * (T_s-T_inf)*D_out^3/nu^2;

Tlm = (((T_in-T_inf)-(T_out-T_inf))/(log((T_in-T_inf)/(T_out-T_inf))));

%R        = log(D_out / D_in) / (2 * pi * k_c * L);
%Gr       = (g * beta * (T_s - T_inf) * D^3) / (nu^2);
Nu_outer = 0.48 * (Gr_out * Pr)^(1/4);
Nu_inner = 0.037 * (Re_in^0.75 - 180) * (Pr^0.42);
h_in = Nu_inner * k_w/D_in; 
h_out = Nu_outer * k_w/D_out; 

syms L 
R_required = Tlm/Qrate;
R_in = 1/(h_in * (2*pi*(D_in/2)*L)); 
R_out = 1/(h_out * (2*pi*(D_out/2)*L)); 
R_pipe = (log(D_out/D_in)/(2*pi*k_c*L)); % L needs to be solved 
R_tot = R_out + R_in + R_pipe; 
L = vpa(solve(R_tot==R_required, L))
disp(vpa(R_in))
disp(vpa(R_out))
disp(vpa(R_pipe))