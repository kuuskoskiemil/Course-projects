alpha = 0.8;
eps = 0.9;
A = 2;
G = 1200;
Tamb = 323;
Tsky = 280;
sigma = 5.670374419e-8;

h = [10, 25, 50];

T0 = 350;          % initial guess [K]
tol = 1e-6;        % convergence tolerance
max_iter = 1000;

for j = 1:length(h)

    T = T0;

    for n = 1:max_iter

        Tnew = (alpha*G ...
              - eps*sigma*(T^4 - Tsky^4) ...
              + h(j)*Tamb) / h(j);

        if abs(Tnew - T) < tol
            break
        end

        T = Tnew;
    end

    fprintf('h = %d W/(m^2 K): T = %.2f °C\n', ...
            h(j), Tnew - 273.15);
end