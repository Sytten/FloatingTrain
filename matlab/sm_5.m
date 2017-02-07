%Félix Landry
%Date de création : 5 février 2017
%Date d'édition
%Description du programme: simulateur pour le banc d'essai

clear all 
clc


masseS = 8/1000; %masse sphere
masseP = 425/1000;%masse plaque
inertiePx = 1169.1;%inertie de plaque sur axe x
inertiePy = 1169.1; %inertie de plaque sur axe y
% %position inertielle des elements K
% XK
% YK
% ZK 
% %position sphere
% Px
% Py
% Pz 
% %vitesse de la sphere
% Vx
% Vy
% Vz 
% 
% Ax %angle phi
% Ay %angle theta
% %vitesse angulaire plaque 
% Wx
% Wy
% %force applique
% FA
% FB
% FC
% %couple applique
% MA
% MB
% MC
% %tension aux actionneurs
% VA
% VB
% VC
% %courant aux actionneurs
% IA
% IB
% IC
%constante
g = -9.8;
rayonS = 3.9 / 1000;  
R = 95.2/1000;

syms  z(t) theta(t) phy(t)  

FA = 1;
FB = 1;
FC = 100;

Px = 0;
Py = 0;
%Dynamique de la plaque
eqn1 = (FA + FB + FC + masseP*g + masseS*g) /(masseP + masseS) == diff(z,2);
eqn2 = (-FA*R - (FB + FC)*R*cos(pi/3) - masseS*g*Px) / inertiePx == diff(theta, 2);
eqn3 = ((FB+FC)*R*sin(pi/3) + masseS*g*Py) / inertiePy == diff(phy,2);


cond = z(0) == 0 ;
Dz = diff(z);
cond1 = Dz(0) == 0;
zSol = dsolve(eqn1,cond, cond1)



cond2 = theta(0) == 0;
Dtheta = diff(theta);
cond4 = Dtheta(0) == 0;

thetaSol = dsolve(eqn2, cond2, cond4)



cond5 = phy(0) == 0;
Dphy = diff(phy);
cond6 = Dphy(0) == 0;

phySol = dsolve(eqn3, cond5, cond6)


%Dynamique de la sphere
syms  x(t) y(t);

theta = 2*pi;
Js = 2/5*(masseS*rayonS^2);
eqn4 = -(theta*(masseS*g))/((masseS + Js/rayonS^2)) == diff(y,2);
eqn5 = diff(x,2) == -(theta*(masseS*g))/((masseS + Js/rayonS^2));

 cond7 = y(0) == 0;
 Dy = diff(y);
 cond8 = Dy(0) == 0;
 ySol = dsolve(eqn4, cond7, cond8)

  cond9 = x(0) == 0;
 Dx = diff(x);
 cond10 = Dx(0) == 0;
 xSol = dsolve(eqn5,cond9, cond10)

figure(1)
subplot(2,3,1)
fplot(zSol);
title('hauteur z');

subplot (2,3,2)
fplot(thetaSol);
title('theta')

subplot(2,3,3)
fplot(phySol);
title('phy')

subplot(2,3,4)
fplot(ySol)
title('y sphere')

subplot(2,3,5)
fplot(xSol)
title('x sphere')


