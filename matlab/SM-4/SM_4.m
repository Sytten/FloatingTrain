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
        
        0,0,0,                                           0,0,0,  0,0,0;
        0,0,0,                                           0,0,0,  0,0,0;
        
        0,-masseS*g/(masseS+inertieS/rayon_sphere^2),0,  0,0,0,  0,0,0;
        masseS*g/(masseS+inertieS/rayon_sphere^2),0,0,   0,0,0,  0,0,0;
        
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

C_plaque_iden = eye(9);
 
 C3_3 = [Yd,-Xd,1;
         Ye,-Xe,1;
         Yf,-Xf,1];
 

D = zeros(7,3);

D_plaque = zeros(3,3);

% 
% Aphi = [A13_13([1 4 11],1),A13_13([1 4 11],4),A13_13([1 4 11],11)];
% Atheta = [A13_13([2 5 12],2),A13_13([2 5 12],5),A13_13([2 5 12],12)];
% Az = [A13_13([3 6 13],3),A13_13([3 6 13],6),A13_13([3 6 13],13)];
% 
% Bphi = [B13_3([1 4 11],1)];
% Btheta = [B13_3([2 5 12],2)];
% Bz = [B13_3([3 6 13],3)];
% 
% Cphi = [Yd, 0, 0; 
%         Ye, 0, 0; 
%         Yf, 0, 0];
%     
% Ctheta = [-Xd, 0,0;
%           -Xe,0,0; 
%           -Xf,0,0];
%       
% Cz = [1,0,0;
%       1,0,0;
%       1,0,0];

% Dphi = [0;0;0];
% Dtheta = [0;0;0];
% Dz = [0;0;0];

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

% AxS = [A13_13([7 9],7),A13_13([7 9],9)];
% AyS = [A13_13([8 10],8),A13_13([8 10],10)];

B4_3 = [0, 0, 0;
        0, 0, 0;
        
        0, 0, acc;
        0, -acc, 0];
    
B_sphere = B4_3;

% BxS = [0, 0; 0, acc];
% ByS = [0, 0; -acc, 0];

% phi est l'entree de y_sphere
% theta est l'entree de x_sphere

C4_4 = eye(4);
C_sphere = C4_4;
% 
% CxS = [1, 1; 1,1]; % PAS CERTAIN!!!
% CyS = [1, 1; 1, 1]; % PAS CERTAIN!!!
% 
% DxS = [0,0;0,0];
% DyS = [0,0;0,0];

D_Sphere = zeros(4,3);

% State-space pour la sphere
% [b_xs, a_xs] = ss2tf(AxS,BxS,CxS,DxS,2);
% 
% [b_ys, a_ys] = ss2tf(AyS,ByS,CyS,DyS,2);




