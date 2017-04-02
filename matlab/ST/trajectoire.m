%% Constants
clear all
close all
clc

trainSize = 0.5;
pas = 101; % Pas integration
T = 1/30; % Periode echantillonage
V = 1; % vitesse constante

aller = [1, 2, 3, 4, 5, 6;4.5, 2.6, 4.5, 2.8, 3.2, 4.6]; % X, Y
retour = [1, 2, 3, 4, 5, 6;7.4, 10.1, 13, 10, 11, 7.5]; % X, Y


%% Trajectoires Aller
% interpole aller
[aller_coeff] = polyfit(aller(1,:),aller(2,:),length(aller)-1);
dx = (length(aller)-1)/pas;
x = 1:dx:length(aller);
aller_int = [x; polyval(aller_coeff, x)];

% calcul longueur & erreur
aller_coeff_d = polyder(aller_coeff); % f'
aller_d = polyval(aller_coeff_d, x);
aller_long = sqrt(1 + aller_d.^2); % g
L = trapz(x, aller_long);

aller_coeff_d2 = polyder(aller_coeff_d); % f''
aller_d2 = polyval(aller_coeff_d2, x);
aller_long_d = aller_d.*aller_d2./aller_long; %g'
E = dx^2/2*(aller_long_d(end)-aller_long_d(1));

% vitesse reelle
O = ceil(L/(T*V));
Vreel = L/(T*O);

% distance entre chaque point
d = L/O;

dx2 = (length(aller)-1)/O;
x2 = 1:dx2:length(aller);
g = polyval(aller_coeff_d, x2);
g = sqrt(1 + g.^2); % g
points = [];
Ltr = [0];
xi = 1;
for i = 1:O
    Ltr(i) = d*(i-1);
    xi = xi + d/g(i);
    points = [points, xi];
end

points = [points; polyval(aller_coeff, points)];

%% Trajectoire Retour
% interpole retour
% [retour_coeff] = polyfit(retour(1,:),retour(2,:),length(retour)-1);
% retour_int = 1:dx:length(retour);
% retour_int = [retour_int; polyval(retour_coeff, retour_int)];


%% Relier gauche
% % interpole gauche
% gauche = [fliplr(aller(:,1:2)) retour(:,1:2)];
% gauche = [gauche(2,:);gauche(1,:)];
% 
% [gauche_coeff] = polyfit(gauche(1,:),gauche(2,:),length(gauche)-1);
% gauche_int = gauche(1,1):dx:gauche(1,end);
% gauche_int = [gauche_int; polyval(gauche_coeff, gauche_int)];
% 
% [~,half_g] = min(gauche_int(2,:));
% 
% % reconstruction aller gauche
% gauche_inv = [gauche_int(2,1:half_g-1);gauche_int(1,1:half_g-1)];
% aller_int = [fliplr(gauche_inv) aller_int(:,1/dx+1:end)];
% 
% % reconstruction retour gauche
% gauche_inv = [gauche_int(2,half_g:end);gauche_int(1,half_g:end)];
% retour_int = [gauche_inv retour_int(:,1/dx+1:end)];


%% Relier Droite
% % interpole droite
% droite = [aller(:,5:end) fliplr(retour(:,5:end))];
% droite = [droite(2,:); droite(1,:)];
% 
% [droite_coeff] = polyfit(droite(1,:),droite(2,:),length(droite)-1);
% droite_int = droite(1,1):dx:droite(1,end);
% droite_int = [droite_int; polyval(droite_coeff, droite_int)];
% [~,half_d] = max(droite_int(2,:));
% 
% % reconstruction aller droite
% droite_inv = [droite_int(2,1:half_d-1);droite_int(1,1:half_d-1)];
% aller_int = [aller_int(:,1:end-1/dx) droite_inv];
% 
% % reconstruction retour droite
% droite_inv = [droite_int(2,half_d:end);droite_int(1,half_d:end)];
% retour_int = [retour_int(:,1:end-1/dx) fliplr(droite_inv)];


%% Affichage
figure 
hold on
plot(aller(2,:), 'o')

% plot(retour(2,:), 'o')
plot(aller_int(1,:),aller_int(2,:));
plot(points(1,:),points(2,:), 'x');
% plot(retour_int(1,:),retour_int(2,:));


%% Write
% csvwrite('retour.csv', fliplr(retour_int)')
% csvwrite('aller.csv', aller_int')

