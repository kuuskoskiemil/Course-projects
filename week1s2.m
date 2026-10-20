h1 = 8.09;
h2 = 40;
A = 0.029688;
c_p = 4190; 
m = 0.38484510006;
Tinf = 2;
T0 = 22;
steps = 3*3600;
Ts1 = zeros(0,steps);
Ts2 = zeros(0,steps);

dt = 1; 
Tn = T0;
time = linspace(0,steps);

t = linspace(0,steps,steps);
T = (T0-Tinf)*exp((-h1*A)/(c_p*m)*t)+Tinf;

Ts1(1) = T0; 
Ts2(1) = T0;


figure('Name','Temps')
plot(t/3600,T,LineWidth=3); 
hold on 


for k = 1: 10800
    
    dT = -dt * (h1*A)/(c_p*m)*(Tn-Tinf);
    Ts1(k) = dT+Tn;
    Tn = Tn + dT;
end 


plot(t/3600,Ts1,'r--',linewidth = 3)
hold on 
T2 = (T0-Tinf)*exp((-h2*A)/(c_p*m)*t)+Tinf;
plot(t/3600,T2,linewidth = 3, Color = 'Y');

hold on 
Tn = T0;

for k = 1: 10800
    
    dT = -dt * (h2*A)/(c_p*m)*(Tn-Tinf);
    Ts2(k) = dT+Tn;
    Tn = Tn + dT;
end 
plot(t/3600,Ts2,'g--',LineWidth=3)
hold on

yline(6,linewidth=3);
yline(2)

legend('analytical h=8.09', 'numerical, h=8.09','analytical, h=12', 'numerical, h=12','T reference (T = 6C)')
xlabel('Time (hours)')
ylabel('Temperature (celcius)')
title('Tölkin jäähtyminen')