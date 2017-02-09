% Auteur : Jordan Careau-Beaulieu, Jean-Pascal McGee
% Date de cr�ation : 09 f�vrier 2017
% Date d'�dition : 09 f�vrier 2017
% Description du programme : Calcul de l'acc�l�ration de la bille en
% fonction de l'angle de la plaque

clear all
clc
close all


g = 9.81;               % Acc�l�ration gravitationnelle.
masseS = 8/1000;        % Masse de la sph�re en kilogrammes.
masseP = 425/1000;      % Masse de la plaque en kilogrammes.
rayon_sphere = 3.9/1000;    % Rayon de la sph�re en m.
inertiePx = 1169.1/(1000^2); % Interie de la plaque en kg*m^2
inertiePy = inertiePx;
inertieS = (2*masseS*(rayon_sphere^2))/5; % Inertie de la sph�re en kg*m^2

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
xlabel('Angle \phi (degr�)');
ylabel('Acc�l�ration m/s^2');
title('Acc�leration en Y de la bille en fonction de l''angle de la plaque.');
subplot(2,1,2);
plot(phi, accelerationX);
grid on;
xlabel('Angle \theta (degr�)');
ylabel('Acc�l�ration m/s^2');
title('Acc�leration en X de la bille en fonction de l''angle de la plaque.');














