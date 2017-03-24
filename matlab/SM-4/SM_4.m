% Auteur : Julien Larochelle, Antoine Mailhot et Philippe Girard
% Date de création : 2017-03-16
% Date d'édition : 2017-03-19
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

%% Load constants

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
tf_phi = ss(Aphi, Bphi, Cphi, Dphi);
sys_tf_phi = tf(tf_phi);

tf_theta = ss(Atheta, Btheta, Ctheta, Dtheta);
sys_tf_theta = tf(tf_theta);

tf_z = ss(Az, Bz, Cz, Dz);
sys_tf_z = tf(tf_z);


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
[b_tf_xs, a_tf_xs] = ss2tf(AxS,BxS,CxS,DxS,2);
[b_tf_ys,a_tf_ys] = ss2tf(AyS,ByS,CyS,DyS,2);
