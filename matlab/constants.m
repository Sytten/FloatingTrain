% Auteur : Jordan Careau-Beaulieu, Jean-Pascal McGee, Antoine Mailhot
% Date de creation : 09 fevrier 2017
% Date d'edition : mars r 2017
% Description du programme : Calcul de l'acceleration de la bille en
% fonction de l'angle de la plaque

clear all
clc
close all


%Declaration des constantes
as0 = 0.0586667067;  %Les constantes ae et as sont obtenues a partir de SC1.
as1 = 22.41055234;
as2 = 860.3941759;
as3 = 233710.9087;
ae0 = 1.325400315;
ae1 = 366.4392052;
ae2 = -30.42916186;
ae3 = 787041.4323;
be1 = 13.029359254409743; % Obtenu a partir du document specifications



g = 9.81;               % Acceleration gravitationnelle.
masseS = 8/1000;        % Masse de la sphere en kilogrammes.
masseP = 425/1000;      % Masse de la plaque en kilogrammes.
rayon_sphere = 3.9/1000;    % Rayon de la sphere en m.
inertiePx = 1169.1/(1000^2); % Inertie de la plaque en kg*m^2
inertiePy = inertiePx;
inertieS = (2*masseS*(rayon_sphere^2))/5; % Inertie de la sphere en kg*m^2
z_range  = 22.2e-03;  
rDEF = 80.00e-03;    % Distance 2D du centre des aimants effet Hall au centre de la plaque
rABC = 95.20e-03;     % Distance 2D du centre des aimants de sustentation au centre de la plaque
A_range = (z_range/rABC)/(2*sqrt(2));

acc = -(masseS*g)/(masseS+inertieS/(rayon_sphere^2));
msg_ip = (masseS*g)/inertiePx;
Ip = 1169.1; % kg*mm^2

mU_ABC = [1 1 1];

% Param?tres electriques des actionneurs
RR = 3.6;
LL = .115;

% Resistances et bobines
Ra = RR;
Rb = RR;
Rc = RR;
La = LL;
Lb = LL;
Lc = LL;
ra_la = Ra / La;
rb_lb = Rb / Lb;
rc_lc = Rc / Lc;

%Positions actionneurs
XA=rABC;
XB=-rABC*sind(30);
XC=-rABC*sind(30);
YA=0;
YB=rABC*cosd(30);
YC=-rABC*cosd(30);
Yd = +rDEF*cosd(30);
Xd = +rDEF*sind(30);
Ye = 0.0;
Xe = -rDEF;
Yf = -rDEF*cosd(30);
Xf = +rDEF*sind(30);


%Valeurs a l'equilibre
ia_e=1;
ib_e=1;
ic_e=1;
z_e=1;
phi_e=1;
theta_e=1;
za_e=z_e+phi_e*YA-theta_e*XA;
zb_e=z_e+phi_e*YB-theta_e*XB;
zc_e=z_e+phi_e*YC-theta_e*XC;


%Constantes de Forces
dFa_dia_e = 1/(ae0+ae1*za_e+ae2*za_e^2+ae3*za_e^3)*2*ia_e*sign(ia_e)+be1;
dFb_dib_e = 1/(ae0+ae1*zb_e+ae2*zb_e^2+ae3*zb_e^3)*2*ib_e*sign(ib_e)+be1;
dFc_dic_e = 1/(ae0+ae1*zc_e+ae2*zc_e^2+ae3*zc_e^3)*2*ic_e*sign(ic_e)+be1;

dFa_dPhi_e = YA*((ia_e^2+be1*abs(ia_e))*sign(ia_e))/(ae0+ae1*za_e+ae2*za_e^2+ae3*za_e^3)*(ae1+2*ae2*za_e+3*ae3*za_e^2)   +   YA/(as0+as1*za_e+as2*za_e^2+as3*za_e^3)*(as1+2*as2*za_e+3*as3*za_e^2);
dFa_dTheta_e = -XA*((ia_e^2+be1*abs(ia_e))*sign(ia_e))/(ae0+ae1*za_e+ae2*za_e^2+ae3*za_e^3)*(ae1+2*ae2*za_e+3*ae3*za_e^2)   +   -XA/(as0+as1*za_e+as2*za_e^2+as3*za_e^3)*(as1+2*as2*za_e+3*as3*za_e^2);
dFa_dz_e = ((ia_e^2+be1*abs(ia_e))*sign(ia_e))/(ae0+ae1*za_e+ae2*za_e^2+ae3*za_e^3)*(ae1+2*ae2*za_e+3*ae3*za_e^2)   +   1/(as0+as1*za_e+as2*za_e^2+as3*za_e^3)*(as1+2*as2*za_e+3*as3*za_e^2);

dFb_dPhi_e = YB*((ib_e^2+be1*abs(ib_e))*sign(ib_e))/(ae0+ae1*zb_e+ae2*zb_e^2+ae3*zb_e^3)*(ae1+2*ae2*zb_e+3*ae3*zb_e^2)   +   YB/(as0+as1*zb_e+as2*zb_e^2+as3*zb_e^3)*(as1+2*as2*zb_e+3*as3*zb_e^2);
dFb_dTheta_e =-XB*((ib_e^2+be1*abs(ib_e))*sign(ib_e))/(ae0+ae1*zb_e+ae2*zb_e^2+ae3*zb_e^3)*(ae1+2*ae2*zb_e+3*ae3*zb_e^2)   +   -XB/(as0+as1*zb_e+as2*zb_e^2+as3*zb_e^3)*(as1+2*as2*zb_e+3*as3*zb_e^2);
dFb_dz_e = ((ib_e^2+be1*abs(ib_e))*sign(ib_e))/(ae0+ae1*zb_e+ae2*zb_e^2+ae3*zb_e^3)*(ae1+2*ae2*zb_e+3*ae3*zb_e^2)   +   1/(as0+as1*zb_e+as2*zb_e^2+as3*zb_e^3)*(as1+2*as2*zb_e+3*as3*zb_e^2);

dFc_dPhi_e = YC*((ic_e^2+be1*abs(ic_e))*sign(ic_e))/(ae0+ae1*zc_e+ae2*zc_e^2+ae3*zc_e^3)*(ae1+2*ae2*zc_e+3*ae3*zc_e^2)   +   YC/(as0+as1*zc_e+as2*zc_e^2+as3*zc_e^3)*(as1+2*as2*zc_e+3*as3*zc_e^2);
dFc_dTheta_e =-XC*((ic_e^2+be1*abs(ic_e))*sign(ic_e))/(ae0+ae1*zc_e+ae2*zc_e^2+ae3*zc_e^3)*(ae1+2*ae2*zc_e+3*ae3*zc_e^2)   -  XC/(as0+as1*zc_e+as2*zc_e^2+as3*zc_e^3)*(as1+2*as2*zc_e+3*as3*zc_e^2);
dFc_dz_e = ((ic_e^2+be1*abs(ic_e))*sign(ic_e))/(ae0+ae1*zc_e+ae2*zc_e^2+ae3*zc_e^3)*(ae1+2*ae2*zc_e+3*ae3*zc_e^2)   +   1/(as0+as1*zc_e+as2*zc_e^2+as3*zc_e^3)*(as1+2*as2*zc_e+3*as3*zc_e^2);

dFc_dz_e2=dFc_dz_e; %Pour le systeme decouple

dFa_dPhi_e2 = dFa_dPhi_e; % Voir avec Antoine Mailhot


%Trigo
sin60 = sin(degtorad(60));
cos60 = cos(degtorad(60));

