% Auteur : Jordan Careau-Beaulieu, Jean-Pascal McGee, Antoine Mailhot
% Date de creation : 09 fevrier 2017
% Date d'edition : mars r 2017
% Description du programme : Calcul de l'acceleration de la bille en
% fonction de l'angle de la plaque

clear all
clc
close all

%% Load constants

run('constants.m')

%% Matrices
m0_3x3 = [0 0 0;
         0 0 0;
         0 0 0];
    
m0_2x3 = [0 0 0;
         0 0 0];
     
m0_3x2 = zeros(3,2);
m0_2x2 = zeros(2,2);
m0_3x4 = zeros(3,4);
m0_4x3 = zeros(4,3);
     
m1_4x4 = [1 0 0 0;
         0 1 0 0;
         0 0 1 0
         0 0 0 1 ];

m1_3x3 = [1 0 0;
         0 1 0;
         0 0 1];
          
m1_2x2 = [1 0 ;
         0 1 ];
     
     
mSP_2x3 = [0 acc 0;
          -acc 0 0];
      
mPS_3x2 = [0 msg_ip;
          -msg_ip 0;
          0 0];
      
mPG_3x2 = mPS_3x2;  

mCC_3x3 = [-ra_la 0 0;
          0 -rb_lb 0;
          0 0 -rc_lc];
      
mCV_3x3 = [1/La 0 0;
          0 1/Lb 0;
          0 0 1/Lc];
 
mB = [m0_3x3;
      m0_3x3;
      m0_2x3;
      m0_2x3;
      mCV_3x3];    
  
  
mTTdef = [Yd -Xd 1;
          Ye -Xe 1;
          Yf -Xf 1];
      
mPC_3x3 = [0 dFa_dia_e*((rABC*sin60)/inertiePx) -dFc_dic_e*((rABC*sin60)/inertiePx);
           -dFa_dia_e*(rABC/inertiePx) dFb_dib_e*((rABC*cos60)/inertiePx) dFc_dic_e*((rABC*cos60)/inertiePx);
           dFa_dia_e*(1/(masseP+masseS)) dFb_dib_e*(1/(masseP+masseS)) dFc_dic_e*(1/(masseS+masseP))];

       
U = [YA, YB, YC; -XA, -XB, -XC; 1, 1, 1];
mPP_test = [1/inertiePx, 0, 0; 0, 1/inertiePx, 0;  0, 0, 1/(masseP + masseS)]*U*[dFa_dPhi_e, dFa_dTheta_e, dFa_dz_e; dFb_dPhi_e, dFb_dTheta_e, dFb_dz_e; dFc_dPhi_e, dFc_dTheta_e, dFc_dz_e];
       
       
mPP_3x3 = [(dFb_dPhi_e-dFc_dPhi_e)*((rABC*sin60)/inertiePx), (dFb_dTheta_e-dFc_dTheta_e)*((rABC*sin60)/inertiePx), (dFb_dz_e-dFc_dz_e)*((rABC*sin60)/inertiePx);
           (-dFa_dPhi_e+dFb_dPhi_e*cos60+dFc_dPhi_e*cos60)*(rABC/inertiePx), (-dFa_dTheta_e+dFb_dTheta_e*cos60+dFc_dTheta_e*cos60)*(rABC/inertiePx), (-dFa_dz_e + dFb_dz_e*cos60 + dFc_dPhi_e*cos60)*(rABC/inertiePx);
           (dFa_dPhi_e + dFb_dPhi_e + dFc_dPhi_e )*(1/(masseP + masseS)), (dFa_dTheta_e + dFb_dTheta_e + dFc_dTheta_e )*(1/(masseP + masseS)), (dFa_dz_e + dFb_dz_e + dFc_dz_e )*(1/(masseP + masseS))
           ];            
     
 line1 = [m0_3x3 m1_3x3 m0_3x2 m0_3x2 m0_3x3];
 line2 = [mPP_3x3 m0_3x3 mPS_3x2 m0_3x2 mPC_3x3 ];
 line3 = [m0_2x3 m0_2x3 m0_2x2 m1_2x2 m0_2x3];
 line4 = [mSP_2x3 m0_2x3 m0_2x2 m0_2x2 m0_2x3];
 line5 = [m0_3x3 m0_3x3 m0_3x2 m0_3x2 mCC_3x3];

 A = [line1;line2;line3;line4;line5];

 B = [m0_3x3; m0_3x3; m0_2x3; m0_2x3; mCV_3x3];
    
 C = [mTTdef m0_3x3 m0_3x4 m0_3x3;
      m0_4x3 m0_4x3 m1_4x4 m0_4x3];
  
 C_prime = eye(13);

 D = zeros(7,3);
 
 D_prime = zeros(13,3);

%% Simulation
open_system('DYNctl_ver4_etud_obfusc')
set_param('DYNctl_ver4_etud_obfusc','AlgebraicLoopSolver','LineSearch')
sim('DYNctl_ver4_etud_obfusc')