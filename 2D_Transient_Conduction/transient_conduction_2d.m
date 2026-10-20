set(0,"DefaultAxesFontName","Times New Roman")
set(0,"DefaultAxesFontSize",15)
clear *

Nx=50;
Nxtot=Nx+2;
Ny=50;
Nytot=Ny+2;


Lx=0.5;
Ly=0.2;
dx=Lx/Nx;
dy=Ly/Ny;

yc=Ly/2;
xc=Lx/2;


sigmx=sqrt(0.001);
sigmy=sqrt(0.0001);
Tref=300;
Ta=100;

%Määritetään x/y koordinaattivektorit
x=linspace(dx/2,Lx-dx/2,Nx);
y=linspace(dy/2,Ly-dy/2,Ny);

%kun piirretään 2d kuvaaja, tarvitaan meshgrid-komentoa

[X,Y]=meshgrid(x,y); %riittää vain sisäpisteille

To=Tref+Ta*exp(-((X-xc ).^2)/(2*sigmx^2)-((Y-yc ).^2)/(2*sigmy^2));

%ratkaisun lämpötilakenttä haamukopeilla

%vältetään for silmukka


inx = 2:(Nxtot-1); iny = 2:(Nytot-1);
east = inx+1; west = inx-1;
north = iny+1; south = iny-1;

T=zeros(Nytot,Nxtot);
T(iny,inx)=To;

set_bc;
compute_derivatives;

Tx = (T(iny,east)-T(iny,west))/(2*dx);
Ty = (T(north,inx) - T(south,inx))/(2*dy); 



%S1c) 
%{
Tyy_analytical = (Ta ./ sigmy.^2) .* (((Y - yc).^2 ./ sigmy.^2) - 1) .* exp(-(X - xc).^2 ./ (2 * sigmx.^2) - (Y - yc).^2 ./ (2 * sigmy.^2));
figure(1), clf
s1 = surf(X,Y,Tyy,'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.8);
hold on
s2 = mesh(X, Y, Tyy_analytical, 'EdgeColor', 'red', 'LineWidth', 1);
hold off 
xlabel('X')
ylabel('Y')
zlabel('d^2T/dy^2')
title('Numerical (Cyan Surface) vs Analytical (Red Mesh)')
legend([s1, s2], {'Numerical (Tyy)', 'Analytical'}, 'Location', 'northeast')
grid on
%}


%S1 b) 
%{
dT_dx_analytical = -(Ta .* (X - xc) ./ sigmx.^2) .* exp(-(X - xc).^2 ./ (2 * sigmx.^2) - (Y - yc).^2 ./ (2 * sigmy.^2));
figure(1), clf
s1 = surf(X, Y, Tx, 'FaceColor', 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.8);
hold on
s2 = mesh(X, Y, dT_dx_analytical, 'EdgeColor', 'red', 'LineWidth', 1);
hold off

xlabel('X')
ylabel('Y')
zlabel('dT/dx')
title('Numerical (Cyan Surface) vs Analytical (Red Mesh)')
legend([s1, s2], {'Numerical (Tx)', 'Analytical'}, 'Location', 'northeast')
grid on
%}


alpha=2.3e-5;
Simutime=200; %sekunteja
dt = 0.001;
HowManySteps=round(Simutime/dt);
HowOftenPLot=100;


plot_times = [1, 10, 75, 200]; 
plotSteps = round(plot_times/dt);
plot_idx = 1;



%for silmukka aika-askelten yli

for t=1:HowManySteps
    current_time=t*dt;
   % Reuna-ehdot
    T(iny, 1) = 290;     % Vasen sivu
    T(iny, Nxtot) = 290; % Oikea sivu

% Ylä- ja alareuna eristettyjä (dT/dy = 0)
    T(1, inx) = T(2, inx);
    T(Nytot, inx) = T(Nytot-1, inx);
    compute_derivatives;

    dT= alpha*dt*(Txx+Tyy);
    T(iny,inx)=T(iny,inx)+dT;
 

    if plot_idx <= numel(plotSteps) && t == plotSteps(plot_idx)
        figure(plot_idx), clf
        surf(X, Y, T(iny, inx), 'EdgeColor', 'none')
        xlabel('X'), ylabel('Y'), zlabel('Temperature')
        title(sprintf('Temperature at t = %.1f s', current_time))
        colorbar
        drawnow
        plot_idx = plot_idx + 1;
        zlim([290 380])
    end
end


%figure(2), clf
%surf(X,Y,Tyy) 

%}
