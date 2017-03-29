% Auteur : Julien Larochelle, Antoine Mailhot et Philippe Girard
% Date de création : 2017-03-16
% Date d'édition : 2017-03-19
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

%% Load constants

run('constants.m')

%% Determination des entrées

U = [0,      rABC*sin60, -rABC*sin60;
     -rABC,  rABC*cos60, rABC*cos60 ;
     1,      1,          1,         ];

 U_inv = 1/(YA*(-XB+XC)+YB*(XA-XC)+YC*(-XA+XB))*[-XB+XC, YC-YB, -YB*XC+YC*XB;
                                                 -XC+XA, YA-YC, -YC*XA+YA*XC;
                                                 -XA+XB, YB-YA, -YA*XB+YB*XA];
                                         
%% Systeme plaque

A13_13 = [0,0,0,                                           1,0,0,  0,0,  0,0,  0,0,0;
          0,0,0,                                           0,1,0,  0,0,  0,0,  0,0,0;
          0,0,0,                                           0,0,1,  0,0,  0,0,  0,0,0;
          
          (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,           0,0,0,  0,0,  0,0,  dFa_dia_e/Ip,0,0;  %Ce cas particulier est le cas d'equilibre theta_eq=0, phi_eq=0.
          0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,           0,0,0,  0,0,  0,0,  0,dFa_dia_e/Ip,0;
          0,0,(dFa_dPhi_e2*3)/(masseS+masseP),             0,0,0,  0,0,  0,0,  0,0,dFa_dia_e/(masseS+masseP);
          
          0,0,0,                                           0,0,0,  0,0,  1,0,  0,0,0;
          0,0,0,                                           0,0,0,  0,0,  0,1,  0,0,0;
          
          0,-masseS*g/(masseS+inertieS/rayon_sphere^2),0,  0,0,0,  0,0,  0,0,  0,0,0;
          masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,   0,0,0,  0,0,  0,0,  0,0,0;
          
          0,0,0,                                           0,0,0,  0,0,  0,0,  -Ra/La,0,0;
          0,0,0,                                           0,0,0,  0,0,  0,0,  0,-Rb/Lb,0;
          0,0,0,                                           0,0,0,  0,0,  0,0,  0,0,-Rc/Lc;];
    
      
      
A9_9 = [0,0,0,                                           1,0,0,  0,0,0;
        0,0,0,                                           0,1,0,  0,0,0;
        0,0,0,                                           0,0,1,  0,0,0;
        
        (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,           0,0,0,  dFa_dia_e/Ip,0,0;
        0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,           0,0,0,  0,dFa_dia_e/Ip,0;
        0,0,(dFa_dPhi_e2*3)/(masseS+masseP),             0,0,0,  0,0,dFa_dia_e/(masseS+masseP);
        
        0,0,0,                                           0,0,0,  -Ra/La,0,0;
        0,0,0,                                           0,0,0,  0,-Rb/Lb,0;
        0,0,0,                                           0,0,0,  0,0,-Rc/Lc;];
    
    A_plaque=A9_9;
    

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
    
B_plaque = [0,0,0;
            0,0,0;
            0,0,0;

            0,0,0;
            0,0,0;
            0,0,0;

            1/La,0,0;
            0,1/Lb,0;
            0,0,1/Lc]; 
      
C3_9 = [Yd,-Xd,1,  0,0,0,0,0,0,0,0,0,0;
        Ye,-Xe,1,  0,0,0,0,0,0,0,0,0,0;
        Yf,-Xf,1,  0,0,0,0,0,0,0,0,0,0];
    
C_plaque = [TDEF',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]'];

C3_3_iden = eye(3);

C_plaque_iden = eye(9);
 
 C3_3 = [Yd,-Xd,1;
         Ye,-Xe,1;
         Yf,-Xf,1];
 

D = zeros(7,3);

D_plaque = zeros(3,3);

A_phi = [A9_9([1 4 7],1),A9_9([1 4 7],4),A9_9([1 4 7],7)];
A_theta = [A9_9([2 5 8],2),A9_9([2 5 8],5),A9_9([2 5 8],8)];
A_z = [A9_9([3 6 9],3),A9_9([3 6 9],6),A9_9([3 6 9],9)];

B_phi = [B_plaque(7,:)]';
B_theta = [B_plaque(8,:)]';
B_z = [B_plaque(9,:)]';

C_phi = [C_plaque(1,[1 4 7]);C_plaque(2,[1,4,7]);C_plaque(3,[1,4,7])];
C_theta = [C_plaque(1,[2 5 8]);C_plaque(2,[2,5,8]);C_plaque(3,[2,5,8])];
C_z = [C_plaque(1,[3 6 9]);C_plaque(2,[3,6,9]);C_plaque(3,[3,6,9])];


D_phi = [0;0;0];
D_theta = [0;0;0];
D_z = [0;0;0];

% %State-space pour la plaque
% 
% [b_phi, a_phi] = ss2tf(Aphi, Bphi, Cphi, Dphi);
% 
% [b_theta, a_theta] = ss2tf(Atheta, Btheta, Ctheta, Dtheta);
% 
% [b_z, a_z] = ss2tf(Az, Bz, Cz, Dz);

%% Systeme sphere

A4_4 = [0, 0, 1, 0;
        0, 0, 0, 1;
        0, 0, 0, 0;
        0, 0, 0, 0];
    
A_sphere = A4_4;

AxS = [A13_13([7 9],7),A13_13([7 9],9)];
AyS = [A13_13([8 10],8),A13_13([8 10],10)];

B4_3 = [0, 0, 0;
        0, 0, 0;
        
        0, acc,0;
        -acc, 0,0];
    
B_sphere = B4_3;

BxS = [0; acc];
ByS = [-acc; 0];

% phi est l'entree de y_sphere
% theta est l'entree de x_sphere

C4_4 = eye(4);
C_sphere = C4_4;

CxS = eye(2);
CyS = eye(2);

DxS = [0;0];
DyS = [0;0];

D_Sphere = zeros(4,3);

% State-space pour la sphere
% [b_xs, a_xs] = ss2tf(AxS,BxS,CxS,DxS,2);
% 
% [b_ys, a_ys] = ss2tf(AyS,ByS,CyS,DyS,2);

%simulation
open_system('DYNctl_ver4_etud_obfusc')
set_param('DYNctl_ver4_etud_obfusc','AlgebraicLoopSolver','LineSearch')
sim('DYNctl_ver4_etud_obfusc')


