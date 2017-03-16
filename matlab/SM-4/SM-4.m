% Auteur : Julien Larochelle
% Date de création : 2017-03-16
% Date d'édition :
% Description du programme : Programme pour la systeme des equations
% decouples

clear all
clc
close all

% Les coefficients ont ete trouves avec SC-1
% Coefficients Fs
as0 = 0.0586667067;
as1 = 22.41055234;
as2 = 860.3941759;
as3 = 233710.9087;

% Ceofficients Fe
ae0 = 1.325400315;
ae1 = 366.4392052;
ae2 = -30.42916186;
ae3 = 787041.4323;

r_ABC = 95.2/1000; % en mm
XA = r_ABC;
XB = -r_ABC*sind(30);
XC = -r_ABC*sind(30);
YA = 0;
YB = r_ABC*cosd(30);
YC = -r_ABC*cosd(30);
ZA = 0;
ZB = 0;
XC = 0;

dFa_dia_e = 1;
dFb_dib_e = 1;
dFc_dic_e = 1;
dFa_dPhi_e2 = 1;

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

ra_la = Ra / La;
rb_lb = Rb / Lb;
rc_lc = Rc / Lc;

Ip = 1169.1; % kg*mm^2

A13_13 = [0,0,0,1,0,0,0,0,0;
          0,0,0,0,1,0,0,0,0;
          0,0,0,0,0,1,0,0,0;
          (dFa_dPhi_e2*(YA^2+YB^2+YC^2))/Ip,0,0,0,0,0,dFa_dia_e/Ip,0,0;
          0,(dFa_dPhi_e2*(XA^2+XB^2+XC^2))/Ip,0,0,0,0,0,dFa_dia_e/Ip,0;
          ]
    
C = [mTTdef m0_3x3 m0_3x4 m0_3x3;
      m0_4x3 m0_4x3 m1_4x4 m0_4x3];

D = zeros(7,3);