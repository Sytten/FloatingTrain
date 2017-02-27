% Auteurs : Julien Larochelle, Émilie Fugulin et Philippe Girard 
% Date de création : 20 fevrier 2017 
% Date d'édition : 27 fevrier 2017
% Description du programme : Approximation de données bruitées à l'aide de
% polynome. 

clear all
close all
clc

% Chargé les données en mémoire
load mesures_forces/Fs.mat
load mesures_forces/Fe_attraction.mat

% Calculs pour l'approximation de Fs 

N = 150; % Nombre de points utilisés 
Fs_sub = Fs(1:N);
z = z_pos(1:N);

Fs_prime = -1 ./ Fs_sub;
[Y, RMS, COR] = poly_approx(z, Fs_prime, 3);

disp('Coefficient pour Fs')
disp('Fs(z) = as0 + as1*z + as2*z^2 + as3*z^3')
disp(['Poly : ', num2str(Y')])
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])
disp(' ')
disp(' ')

figure
hold on
plot(z,Fs_sub, 'o')
y = polyval(fliplr(Y'),z);
plot(z, -1 ./ y)
xlabel('Distance z (m)')
ylabel ('Force Fs (N)')
title('Force Fs en fonction de la distance z')
legend('Points Fs','Droite Fs')
legend('Location','southeast')
hold off

% Calculs pour l'approximation de Fe

% Calculs pour l'approximation de Fe 1A
N = 150; % Nombre de points utilisés 
b = 13.029359254409743; % Constante
i = -1; % Courant
C1 = sign(i)*(i^2 + b*abs(i));
Fe1_sub = Fe_m1A(1:N);
z1 = z_m1A(1:N);

Fe1_prime = C1 ./ Fe1_sub;
[Y1, RMS, COR] = poly_approx(z1, Fe1_prime, 3);


% Calculs pour l'approximation de Fe 1A
N = 150; % Nombre de points utilisés 
b = 13.029359254409743; % Constante
i = -2; % Courant
C2 = sign(i)*(i^2 + b*abs(i));
Fe2_sub = Fe_m2A(1:N);
z2 = z_m2A(1:N);

Fe2_prime = C2 ./ Fe2_sub;
[Y2, RMS, COR] = poly_approx(z2, Fe2_prime, 3);

% Moyenne des deux courbes
Y = (Y1 + Y2)./2;
disp('Coefficient pour Fe')
disp('Fe(z) = ae0 + ae1*z + ae2*z^2 + ae3*z^3')
disp(['Poly : ', num2str(Y')])
disp(' ')
disp(' ')
[RMS, COR] = poly_rms_cor(z1, Fe1_prime, fliplr(Y'));
disp('Fe_m1A avec la moyenne des coefficients')
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])
disp(' ')
disp(' ')
[RMS, COR] = poly_rms_cor(z2, Fe2_prime, fliplr(Y'));
disp('Fe_m2A avec la moyenne des coefficients')
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

figure
hold on
plot(z1,Fe1_sub, 'o')
y = polyval(fliplr(Y'),z1);
plot(z1, C1 ./ y)
plot(z2,Fe2_sub, 'o')
y = polyval(fliplr(Y'),z2);
plot(z2, C2 ./ y)
xlabel('Distance z (m)')
ylabel ('Force Fe (N)')
title('Force Fe en fonction de la distance z')
legend('Points Fe 1A','Droite Fe 1a','Points Fe 2A','Droite Fe 2a')
legend('Location','southeast')
hold off