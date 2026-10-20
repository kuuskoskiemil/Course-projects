t = [0,10,20,60];
T_0 = 293; 
T_1 = 20 ;
L = 0.5 ;
alf = 1e-4;
k = 2*pi/L; 
x = linspace(0,0.5,100);

figure ('Name','Lämpötilajakauma')

for (t=[0,10,20,60,inf])
    plot(x,T_0 + T_1*sin(k.*x)*exp(-k^2*alf*t),LineWidth=2);
    hold on;
end
title('Lämpötilajakauma eri ajan hetkillä')
xlabel('paikka (m)')
ylabel('Lämpötila (K)')
legend('t=0','t=10','t=20','t=60','t=inf')