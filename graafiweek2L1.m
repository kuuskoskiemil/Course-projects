%% Lämpötilajakauma seinän läpi
% Seinärakenteiden paksuudet [m]
L1 = 0.012;   % Kipsilevy
L2 = 0.100;   % Kivivilla
L3 = 0.080;   % Tiili

% x-koordinaatit
x0 = 0;
x1 = L1;
x2 = L1 + L2;
x3 = L1 + L2 + L3;

% Lämpötilat [°C]
T_sisailma = 20;
T_sisaseina = 16.98247784;
T1 = 16.19529814426087;
T2 = -17.33272593351691;
T_ulko_seina = -19.057024325;
T_ulkoilma = -20;

% Kaikki pisteet kuvaajaa varten
x = [-0.02 x0 x1 x2 x3 x3+0.02];
T = [T_sisailma T_sisaseina T1 T2 T_ulko_seina T_ulkoilma];

% Piirretään lämpötilajakauma
figure;
plot(x, T, '-o', 'LineWidth', 2, 'MarkerSize', 7);
grid on;
hold on;

% Seinän rajat
xline(x0, '--', 'Seinän sisäpinta', ...
    'LabelVerticalAlignment', 'middle', ...
    'LabelHorizontalAlignment', 'left');
xline(x3, '--', 'Seinän ulkopinta', ...
    'LabelVerticalAlignment', 'middle', ...
    'LabelHorizontalAlignment', 'left');

% Materiaalien rajapinnat
xline(x1, ':', 'Kipsilevy | Kivivilla');
xline(x2, ':', 'Kivivilla | Tiili');

% Materiaalien nimet
text(L1/2, 2, 'Kipsilevy', ...
    'HorizontalAlignment', 'center');
text(L1 + L2/2, 2, 'Kivivilla', ...
    'HorizontalAlignment', 'center');
text(L1 + L2 + L3/2, 2, 'Tiili', ...
    'HorizontalAlignment', 'center');

% Akseleiden nimet
xlabel('Etäisyys seinän läpi x [m]');
ylabel('Lämpötila [°C]');

% Otsikko
title('Lämpötilajakauma seinän läpi');

% X-akselin rajat
xlim([-0.025 x3+0.025]);
hold off;