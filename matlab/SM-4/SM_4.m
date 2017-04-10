% Auteur : Julien Larochelle, Antoine Mailhot et Philippe Girard
% Date de cr�ation : 2017-03-16
% Date d'�dition : 2017-03-19
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

%% Load constants

run('constants.m')

%% Determination des entr�es

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
    
      
      
A_plaque = [0,0,0,                                           1,0,0,  0,0,0;
            0,0,0,                                           0,1,0,  0,0,0;
            0,0,0,                                           0,0,1,  0,0,0;
        
            (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,           0,0,0,  dFa_dia_e/Ip,0,0;
            0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,           0,0,0,  0,dFa_dia_e/Ip,0;
            0,0,(dFa_dPhi_e2*3)/(masseS+masseP),             0,0,0,  0,0,dFa_dia_e/(masseS+masseP);
        
            0,0,0,                                           0,0,0,  -Ra/La,0,0;
            0,0,0,                                           0,0,0,  0,-Rb/Lb,0;
            0,0,0,                                           0,0,0,  0,0,-Rc/Lc;];
    
B_plaque = [0,0,0;
            0,0,0;
            0,0,0;

            0,0,0;
            0,0,0;
            0,0,0;

            1/La,0,0;
            0,1/Lb,0;
            0,0,1/Lc]; 
    
C_plaque = [TDEF',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]',[0,0,0]'];

C3_3_iden = eye(3);

C_plaque_iden = eye(9);

D = zeros(7,3);

D_plaque = zeros(3,3);

A_phi = [A_plaque([1 4 7],1),A_plaque([1 4 7],4),A_plaque([1 4 7],7)];
A_theta = [A_plaque([2 5 8],2),A_plaque([2 5 8],5),A_plaque([2 5 8],8)];
A_z = [A_plaque([3 6 9],3),A_plaque([3 6 9],6),A_plaque([3 6 9],9)];

B_phi = B_plaque([1,4,7],1);
B_theta = B_plaque([2,5,8],2);
B_z = B_plaque([3,6,9],3);

C_phi = [1, 0, 0]; %Permet de sortir seulement 1 variable
C_theta = [1,0,0];
C_z = [1,0,0];

D_phi_1sortie=0;
D_theta_1sortie=0;
D_z_1sortie=0;

D_phi = [0;0;0];
D_theta = [0;0;0];
D_z = [0;0;0];

[num_z, den_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie);
FT_pz = tf(num_z,den_z)

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

BxS = B_sphere([1,3],2); 
ByS = B_sphere([2,4],1);

% phi est l'entree de y_sphere
% theta est l'entree de x_sphere

CxS = eye(2);
CyS = eye(2);

DxS = [0;0];
DyS = [0;0];

%simulation
open_system('DYNctl_ver4_etud_obfusc')
set_param('DYNctl_ver4_etud_obfusc','AlgebraicLoopSolver','LineSearch')
sim('DYNctl_ver4_etud_obfusc')


