clear; clc; close all;
alpha = 0.8;
eps = 0.9;
A = 2;
G = 1200;
Tamb = 323;
Tsky = 280;
sigma = 5.670374419e-8;
h = 25;
%a)
%{
syms T
q1 = eps * sigma * (T^4-Tsky^4)*A;
q2 = alpha * G * A ;
eqn = q1 ==q2;
x = solve(eqn, T);
%}
%b)
%{
Tn = 300*ones(size(h));
for t = 1:1000
    Tn1 = Tamb + (alpha * G - eps * sigma * (Tn.^4 - Tsky^4))./h;
    Tn = Tn1;
end
disp(Tn-273.15)
%}
%c) 1D heat equation through the car roof, for several h values
hvals = [0 10 25 50];

Troofstart = 124 + 273.15;
L  = 5/100;
N  = 50;
Ntot = N+2;
dx = L/N;
x  = linspace(dx/2, L-dx/2, N);

Simutime = 200000;
dt    = 0.01;
steps = round(Simutime/dt);

in   = 2:(Ntot-1);
west = in-1;
east = in+1;

k   = 50;
rho = 7850;
cp  = 470;
thermalalpha = k/(cp*rho);

saveEvery = 100;                    % save one value per 1 s
nSave = floor(steps/saveEvery);
avg   = zeros(numel(hvals), nSave); % one row per h value
tvec  = (1:nSave)*saveEvery*dt;     % time axis in seconds

plot_times = [1, 10, 75, 10000];
plotSteps = round(plot_times/dt);

for ih = 1:numel(hvals)
    h = hvals(ih);

    % reset initial condition for each h
    T0 = Tamb * ones(1,N);
    T  = [Troofstart T0 Tamb];

    plot_idx = 1;
    figure(10+ih); clf
    sgtitle(sprintf('h = %d',h))

    for t = 1:steps
        T(Ntot) = T(Ntot-1);
        qflux = alpha*G - eps*sigma*(T(2)^4 - Tsky^4) - h*(T(2) - Tamb);
        T(1)  = T(2) + dx/k*qflux;

        Txx = (T(east) - 2*T(in) + T(west))/(dx^2);
        T(in) = T(in) + thermalalpha*Txx*dt;

        if mod(t, saveEvery) == 0
            avg(ih, t/saveEvery) = mean(T(in));
        end
        if plot_idx <= numel(plotSteps) && t == plotSteps(plot_idx)
        subplot(2, 2, plot_idx); % Places plot into a 2x2 grid in figure 1
        plot(x * 100, T(in) - 273.15, 'LineWidth', 1.5);
        title(sprintf('t = %d s', plot_times(plot_idx)));
        xlabel('Position x (cm)');
        ylabel('Temperature (°C)');
        grid on;
        plot_idx = plot_idx + 1;
        end

    end
end

figure(2); clf
plot(tvec/3600, avg' - 273.15, 'LineWidth', 1.5);
grid on
xlabel('Time (h)');
ylabel('Average roof temperature (C)');
legend('h = 0', 'h = 10', 'h = 25', 'h = 50');
ax = gca;
ax.XAxis.Exponent = 0;