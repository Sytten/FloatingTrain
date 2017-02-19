%Félix Landry
%Date de création : 5 février 2017
%Date d'édition : 18 février 2017
%Description du programme: simulateur pour le banc d'essai

clear all 
clc

% Constantes
masseS = 8/1000; % masse sphere
masseP = 425/1000;% masse plaque
inertiePx = 1169.1 / (1000^2);% inertie de plaque sur axe x
inertiePy = 1169.1 / (1000^2); % inertie de plaque sur axe y

g = 9.81;
rayonS = 3.9 / 1000;  
R = 95.2/1000;

%Dynamique de la plaque
syms  z(t) theta(t) phi(t)  

FA = -1.42;
FB = -1.42;
FC = -1.42;

Px = 0;
Py = 0;

eqn1 = (FA + FB + FC + masseP*g + masseS*g) /(masseP + masseS) == diff(z,2);
eqn2 = (-FA*R + (FB + FC)*R*cos(pi/3) - masseS*g*Px) / inertiePx == diff(theta, 2);
eqn3 = ((FB-FC)*R*sin(pi/3) + masseS*g*Py) / inertiePy == diff(phi,2);

cond = z(0) == 0 ;
Dz = diff(z);
cond1 = Dz(0) == 0;
zSol = dsolve(eqn1,cond, cond1);

cond2 = theta(0) == 0;
Dtheta = diff(theta);
cond3 = Dtheta(0) == 0;
thetaSol = dsolve(eqn2, cond2, cond3);

cond4 = phi(0) == 0;
Dphi = diff(phi);
cond5 = Dphi(0) == 0;
phiSol = dsolve(eqn3, cond4, cond5);


%Dynamique de la sphere
syms  x(t) y(t);

theta = degtorad(5);
phi = degtorad(5);
Js = 2/5*(masseS*rayonS^2);
eqn4 = -(theta*(masseS*g))/((masseS + Js/rayonS^2)) == diff(y,2);
eqn5 = -(phi*(masseS*g))/((masseS + Js/rayonS^2)) == diff(x,2);

cond6 = y(0) == 0;
Dy = diff(y);
cond7 = Dy(0) == 0;
ySol = dsolve(eqn4, cond6, cond7);

cond8 = x(0) == 0;
Dx = diff(x);
cond9 = Dx(0) == 0;
xSol = dsolve(eqn5,cond8, cond9);


% Affichage
figure(1)
subplot(2,3,1)
fplot(zSol);
title('hauteur z');
xlabel('Temps (s)')
ylabel('Position z (m)')

subplot (2,3,2)
fplot(thetaSol);
title('theta')
xlabel('Temps (s)')
ylabel('Angle \theta (rad)')

subplot(2,3,3)
fplot(phiSol);
title('phi')
xlabel('Temps (s)')
ylabel('Angle \phi (rad)')

subplot(2,3,4)
fplot(ySol)
title('y sphere')
xlabel('Temps (s)')
ylabel('Position y (m)')

subplot(2,3,5)
fplot(xSol)
title('x sphere')
xlabel('Temps (s)')
ylabel('Position x (m)')

