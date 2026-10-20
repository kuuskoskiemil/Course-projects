

set(0,'DefaultAxesFontName','Times New Roman')
set(0,'DefaultAxesFontSize',20)
clear *
Re = linspace(0,100,1000);
y = 1 + 2* Re.^0.5;
fig = figure ('Name', 'Nusselts number');
plot(Re,y)
xlabel('Reynolds number');
ylabel('Nusselt Number');
title('Nusselt Number');
hold on 
plot(100,1 + 2* 100^0.5,'o')
legend('Nu(Re)=1+2Re^{0.5}','Nu(100)')
hold off
print -dpng 'Esitehtavaplotti2.pdf'