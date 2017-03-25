% Auteur : Julien Larochelle, Antoine Mailhot et Philippe Girard
% Date de création : 2017-03-16
% Date d'édition : 2017-03-19
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

%% À déterminé 
% ia = 1;
% ib = 1;
% ic = 1;
% 
% Va = 1;
% Vb = 1;
% Vc = 1;

%% Load constants

run('../constants.m')

%% Determination des entrées

U = [0, rABC*sin60, -rABC*sin60;
     -rABC, rABC*cos60, rABC*cos60;
     1, 1, 1];

 U_inv = 1/(YA*(-XB+XC)+YB*(XA-XC)+YC*(-XA+XB))*[-XB+XC, YC-YB, -YB*XC+YC*XB;
                                             -XC+XA, YA-YC, -YC*XA+YA*XC;
                                             -XA+XB, YB-YA, -YA*XB+YB*XA];
                                         
                                         
                                         
                                      

 % On multiplie U_inv par [iphi; itheta; iz] pour obtenir [iA; iB; iC] 
 
 
 
 
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
    
A9_9 = [0,0,0,1,0,0,0,0,0;
        0,0,0,0,1,0,0,0,0;
        0,0,0,0,0,1,0,0,0;
        (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,0,0,0,dFa_dia_e/Ip,0,0;
        0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,0,0,0,0,dFa_dia_e/Ip,0;
        0,0,(dFa_dPhi_e2*3)/(masseS+masseP),0,0,0,0,0,dFa_dia_e/(masseS+masseP);
        0,0,0,0,0,0,0,0,0;
        0,0,0,0,0,0,0,0,0;
        0,-masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,0,0,0,0,0;
        masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,0,0,0,0,0,0;
        0,0,0,0,0,0,-Ra/La,0,0;
        0,0,0,0,0,0,0,-Rb/Lb,0;
        0,0,0,0,0,0,0,0,-Rc/Lc;];
    
Unitaire9_9  = eye(9);

sA = A9_9 * Unitaire9_9 ;
for i = 1:9
    Variables_etats_Plaque(i) = sum(sA(i,:))';
end

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
    
B3_3 = [1/La,0,0;
        0,1/Lb,0;
        0,0,1/Lc];
    
Unitaire3_3 = eye(3);
sB = B3_3 * Unitaire3_3 ;
for i = 1:3
    Entrees_Plaque(i) = sum(sB(i,:))';
end
      
C3_9 = [Yd,-Xd,1,0,0,0,0,0,0,0,0,0,0;
     Ye,-Xe,1,0,0,0,0,0,0,0,0,0,0;
     Yf,-Xf,1,0,0,0,0,0,0,0,0,0,0];   
 
 C3_3 = [Yd,-Xd,1;
     Ye,-Xe,1;
     Yf,-Xf,1];
 
 sC = B3_3 * Unitaire3_3 ;
for i = 1:3
    Sorties_Plaque(i) = sum(sC(i,:))';
end
 

D = zeros(7,3);

D_Plaque = [0, 0, 0];

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

tf_phi = ss2tf(Aphi, Bphi, Cphi, Dphi);
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
tf_xs = ss(AxS,BxS,CxS,DxS,2);
sys_tf_xs = tf(tf_xs);

tf_ys = ss(AyS,ByS,CyS,DyS,2);
sys_tf_ys = tf(tf_ys);


