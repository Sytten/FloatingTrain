% Auteur : Jordan Careau-Beaulieu, Jean-Pascal McGee
% Date de création : 09 février 2017
% Date d'édition : 09 février 2017
% Description du programme : Calcul de l'accélération de la bille en
% fonction de l'angle de la plaque

clear all
clc
close all


g = 9.81;               % Accélération gravitationnelle.
masseS = 8/1000;        % Masse de la sphère en kilogrammes.
masseP = 425/1000;      % Masse de la plaque en kilogrammes.
rayon_sphere = 3.9/1000;    % Rayon de la sphère en m.
inertiePx = 1169.1/(1000^2); % Interie de la plaque en kg*m^2
inertiePy = inertiePx;
inertieS = (2*masseS*(rayon_sphere^2))/5; % Inertie de la sphère en kg*m^2

delta_phi = 0.01;
phi_min = -5.0;
phi_max = 5.0;
phi = [phi_min:delta_phi:phi_max]';


accelerationY = -(masseS*g.*degtorad(phi))/(masseS + (inertieS/rayon_sphere^2));
accelerationX = accelerationY;

figure;
subplot(2,1,1);
plot(phi, accelerationY);
grid on;
xlabel('Angle \phi (degré)');
ylabel('Accélération m/s^2');
title('Accéleration en Y de la bille en fonction de l''angle de la plaque.');
subplot(2,1,2);
plot(phi, accelerationX);
grid on;
xlabel('Angle \theta (degré)');
ylabel('Accélération m/s^2');
title('Accéleration en X de la bille en fonction de l''angle de la plaque.');














