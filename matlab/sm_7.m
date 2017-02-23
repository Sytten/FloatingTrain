% Auteur : Jordan Careau-Beaulieu, Jean-Pascal McGee
% Date de creation : 09 fevrier 2017
% Date d'edition : 09 fevrier 2017
% Description du programme : Calcul de l'acceleration de la bille en
% fonction de l'angle de la plaque

clear all
clc
close all

% Declaration des constantes
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


mU_ABC = [1 1 1];

% Param?tres electriques des actionneurs
RR = 3.6;
LL = .115;

% Constante a definir
Ra = RR;
Rb = RR;
Rc = RR;
La = LL;
Lb = LL;
Lc = LL;

Yd = +rDEF*cosd(30);
Xd = +rDEF*sind(30);
Ye = 0.0;
Xe = -rDEF;
Yf = -rDEF*cosd(30);
Xf = +rDEF*sind(30);

dFa_dia_e = 1;
dFb_dib_e = 1;
dFc_dic_e = 1;
dFa_dPhi_e = 0;
dFa_dTheta_e = 0;
dFa_dz_e = 1;
dFb_dPhi_e = 1;
dFb_dTheta_e = 1;
dFb_dz_e = 1;
dFc_dPhi_e = 1;
dFc_dTheta_e = 1;
dFc_dz_e = 1;

ra_la = Ra / La;
rb_lb = Rb / Lb;
rc_lc = Rc / Lc;

sin60 = sin(degtorad(60));
cos60 = cos(degtorad(60));

% Matrices
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
       
       
mPP_3x3 = [(dFb_dPhi_e-dFc_dPhi_e)*((rABC*sin60)/inertiePx) (dFb_dTheta_e-dFc_dTheta_e)*((rABC*sin60)/inertiePx) (dFb_dz_e-dFc_dz_e)*((rABC*sin60)/inertiePx);
           (-dFa_dPhi_e+dFb_dPhi_e*cos60+dFc_dPhi_e*cos60)*(rABC/inertiePx) (-dFa_dTheta_e-dFb_dTheta_e*cos60+dFc_dTheta_e*cos60)*(rABC/inertiePx) (-dFa_dz_e + dFb_dz_e*cos60 + dFc_dPhi_e*cos60)*(rABC/inertiePx);
           (dFa_dPhi_e + dFb_dPhi_e + dFc_dPhi_e )*(1/(masseP + masseS)) (dFa_dTheta_e + dFb_dTheta_e + dFc_dTheta_e )*(1/(masseP + masseS)) (dFa_dz_e + dFb_dz_e + dFc_dz_e )*(1/(masseP + masseS))
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

 D = zeros(7,3);

 sim('SimulinkModelisation2016A');
 plot(simout);