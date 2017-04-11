%% Constants
clear all
close all
clc

load('trajectoire.mat')

NAB = NAB';
NBA = flipud(NBA)';

% NAB = NAB +1;
% NBA = NBA +1;

% T = 1/30; % Periode echantillonage
% Valler = 0.5; % vitesse constante
% Vretour = 0.5;
% 
%aller = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0;1.5, 2.2, 2.8, 3.5, 2.5, 2.0, 3.0]; % X, Y
%retour = [1, 2, 3, 4, 5, 6;7.4, 10.1, 13, 10, 11, 7.5]; % X, Y


%% Trajectoires Aller
[coeff, Ltr, E, Vr, M, tt, O] = interpolation(NAB,vAB,Ts);

%% Trajectoire Retour
[coeff1, Ltr1, E1, Vr1, M1, tt1, O1] = interpolation(NBA,vBA,Ts);

%% Relier gauche
% dx = (length(aller)-1)/101;
% % interpole gauche
% gauche = [fliplr(aller(:,1:2)) retour(:,1:2)];
% gauche = [gauche(2,:);gauche(1,:)];
% 
% [gauche_int,points3] = interpolation(gauche,V,T);
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
plot(NAB(1,:), NAB(2,:), 'o')
plot(NBA(1,:), NBA(2,:), 'o')

plot(M(1,:),M(2,:));
plot(O(1,:),O(2,:), 'x');

plot(M1(1,:),M1(2,:));
plot(O1(1,:),O1(2,:), 'x');

%% Write
csvwrite('aller.csv', O')
csvwrite('retour.csv', fliplr(O1)')

