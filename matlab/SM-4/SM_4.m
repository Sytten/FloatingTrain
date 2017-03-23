% Auteur : Julien Larochelle, Antoine Mailhot et Philippe Girard
% Date de création : 2017-03-16
% Date d'édition : 2017-03-19
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

% % Les coefficients ont ete trouves avec SC-1
% % Coefficients Fs
% as0 = 0.0586667067;
% as1 = 22.41055234;
% as2 = 860.3941759;
% as3 = 233710.9087;
% 
% % Ceofficients Fe
% ae0 = 1.325400315;
% ae1 = 366.4392052;
% ae2 = -30.42916186;
% ae3 = 787041.4323;
% 
% r_ABC = 95.2; % en mm
% r_DEF = 80; % en mm
% XA = r_ABC;
% XB = -r_ABC*sind(30);
% XC = -r_ABC*sind(30);
% XD = r_DEF*cosd(30);
% XE = -r_DEF;
% XF = r_DEF*sind(30);
% YA = 0;
% YB = r_ABC*cosd(30);
% YC = -r_ABC*cosd(30);
% YD = r_DEF*cosd(30);
% YE = 0;
% YF = -r_DEF*cosd(30);
% ZA = 0;
% ZB = 0;
% ZC = 0;
% 
% % Constante d'équilibre trouvees avec SS-2
% dFa_dia_e = 1;
% dFb_dib_e = 1;
% dFc_dic_e = 1;
% dFa_dPhi_e2 = 1;
% 
% % Param?tres electriques des actionneurs
% RR = 3.6;
% LL = .115;
% 
% % Constante a definir
% Ra = RR;
% Rb = RR;
% Rc = RR;
% La = LL;
% Lb = LL;
% Lc = LL;
% 
% ra_la = Ra / La;
% rb_lb = Rb / Lb;
% rc_lc = Rc / Lc;
% 
% g = 9.81;               % Acceleration gravitationnelle.
% masseS = 8/1000;        % Masse de la sphere en kilogrammes.
% masseP = 425/1000;      % Masse de la plaque en kilogrammes.
% rayon_sphere = 3.9/1000;    % Rayon de la sphere en m.
% inertiePx = 1169.1/(1000^2); % Inertie de la plaque en kg*m^2
% inertiePy = inertiePx;
% inertieS = (2*masseS*(rayon_sphere^2))/5; % Inertie de la sphere en kg*m^2
% acc = -(masseS*g)/(masseS+inertieS/(rayon_sphere^2));
% 
% Ip = 1169.1; % kg*mm^2

run('../constants.m')

%% Systeme plaque

A13_13 = [0,0,0,1,0,0,0,0,0,0,0,0,0;
          0,0,0,0,1,0,0,0,0,0,0,0,0;
          0,0,0,0,0,1,0,0,0,0,0,0,0;
        (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,0,0,0,0,0,0,0,dFa_dia_e/Ip,0,0;
        0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,0,0,0,0,0,0,0,0,dFa_dia_e/Ip,0;
        0,0,(dFa_dPhi_e2*3)/(masseS+masseP),0,0,0,0,0,0,0,0,0,dFa_dia_e/(masseS+masseP);
        0,0,0,0,0,0,0,0,1,0,0,0,0;
        0,0,0,0,0,0,0,0,0,1,0,0,0;
        0,-masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,0,0,0,0,0,0,0,0,0;
        masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,0,0,0,0,0,0,0,0,0,0;
        0,0,0,0,0,0,0,0,0,0,-Ra/La,0,0;
        0,0,0,0,0,0,0,0,0,0,0,-Rb/Lb,0;
        0,0,0,0,0,0,0,0,0,0,0,0,-Rc/Lc;];
    

B13_3 = [0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        0,0,0;
        1/La,0,0;
        0,1/Lb,0;
        0,0,1/Lc];
      
C = [Yd,-Xd,1,0,0,0,0,0,0,0,0,0,0;
     Ye,-Xe,1,0,0,0,0,0,0,0,0,0,0;
     Yf,-Xf,1,0,0,0,0,0,0,0,0,0,0;
     0,0,0,0,0,0,1,0,0,0,0,0,0;
     0,0,0,0,0,0,0,1,0,0,0,0,0;
     0,0,0,0,0,0,0,0,1,0,0,0,0;
     0,0,0,0,0,0,0,0,0,1,0,0,0;];    

D = zeros(7,3);

Aphi = [A13_13([1 4 11],1),A13_13([1 4 11],4),A13_13([1 4 11],11)];
Atheta = [A13_13([2 5 12],2),A13_13([2 5 12],5),A13_13([2 5 12],12)];
Az = [A13_13([3 6 13],3),A13_13([3 6 13],6),A13_13([3 6 13],13)];

Bphi = [B13_3([1 4 11],1)];
Btheta = [B13_3([2 5 12],2)];
Bz = [B13_3([3 6 13],3)];

Cphi = [Yd, 0, 0; Ye, 0, 0; Yf, 0, 0];
Ctheta = [-Xd, 0,0; -Xe,0,0; -Xf,0,0];
Cz = [1,0,0;1,0,0;1,0,0];

Dphi = [0;0;0];
Dtheta = [0;0;0];
Dz = [0;0;0];

%State-space pour la plaque
tf_phi =ss2tf(Aphi, Bphi, Cphi, Dphi);
tf_theta =ss2tf(Atheta, Btheta, Ctheta, Dtheta);
tf_z =ss2tf(Az, Bz, Cz, Dz);

%% Systeme sphere

AxS = [A13_13([7 9],7),A13_13([7 9],9)];
AyS = [A13_13([8 10],8),A13_13([8 10],10)];

BxS = [0, 0; 0, acc];
ByS = [0, 0; -acc, 0];

% phi est l'entree de y_sphere
% theta est l'entree de x_sphere
CxS = [1, 1; 1,1];
CyS = [1, 1; 1, 1];

DxS = [0,0;0,0];
DyS = [0,0;0,0];

% State-space pour la sphere
tf_xs = ss2tf(AxS,BxS,CxS,DxS,2);
tf_ys = ss2tf(AyS,ByS,CyS,DyS,2);
