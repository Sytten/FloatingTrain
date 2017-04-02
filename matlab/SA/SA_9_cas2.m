% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-02
% Description du programme : Asservissement
clc
close all
clear all

%% Génération des ft z de la plaque
run('SM_4.m')

PM_des = 25;
wg_des = 185;
eRP = 0.0004; %cas 1
%eRP = 0; % echelon 0


[num_z, den_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie);
ft_z = tf(num_z,den_z);
ftbf_z = feedback(ft_z,1);

%% analyse PHI non comepnsé
t = linspace(0,0.50,5000);
u = ones(size(t));
y_z = lsim(ftbf_z,u,t);
figure
hold
plot(t,y_z)
plot(t,u,'--k')
title('Réponse à l''échelon de ftbf z non compensée')
xlabel('temps (s)')
ylabel('angle (deg)')
print('rep_ech_z_non_compense','-dpng','-r300')

figure
rlocus(ft_z)
print('rlocus_z_non_compense','-dpng','-r300')


%% Conception de l'asservissement

%2 dessiner le diagramme de bode sans compensation
figure
margin(ft_z)
[Gm0,Pm0,Wg0,Wp0] = margin(ft_z)
disp(['PM = ', num2str(Pm0),' deg'])
disp(['GM = ', num2str(Gm0),' dB'])
disp(['Wg = ', num2str(Wp0),' rad/s'])
disp('On ne rencontre pas les criteres de performance')

%3 Calculer le gain K_des pour avoir une bonne compensation
[mag, pha] = bode(ft_z,wg_des)
K_des = 1/mag
%4 dessiner le lieu de bode avec le gain K_des
figure
margin(K_des*ft_z)
[Gm1,Pm1,Wg1,Wp1] = margin(K_des*ft_z)
disp(['PM = ', num2str(Pm1),' deg'])
disp(['GM = ', num2str(Gm1),' dB'])
disp(['Wg = ', num2str(Wp1),' rad/s'])
disp('La frequence de traverse est bonne mais pas la PM')

% 5 compensation du lieu de bode
delta_phi = PM_des - Pm1 + 6;
 
%6 calcul du parametre alpha
alpha = (1-sind(delta_phi))/(1+sind(delta_phi));

%7 calcul du parametre T
T = 1/(wg_des*sqrt(alpha));

%8 calculer les frequence de coupure
z = -1/T;
p = -1/(alpha*T);

%9 calcul du gain Ka
Ka = K_des/sqrt(alpha);
num_C = Ka*[1 -z];
den_C = [1 -p];
G_AvPh = tf(num_C,den_C); 
GA = Ka*G_AvPh;

%10 Verifier que les exigences sont rencontrees
figure
FTBO_F = G_AvPh*ft_z;
FTBF = feedback(FTBO_F,1);
margin(FTBO_F)
BW2 = bandwidth(feedback(FTBO_F,1))
[Gm2,Pm2,Wg2,Wp2] = margin(K_des*FTBO_F)
disp(['PM = ', num2str(Pm2),' deg'])
disp(['GM = ', num2str(Gm2),' dB'])
disp(['Wg = ', num2str(Wp2),' rad/s'])
disp(['BW = ', num2str(BW2),' rad/s'])
disp('La frequence de traverse est bonne mais pas la PM')

figure % reponse a echelon
step(FTBF)
[num_F, den_F] = tfdata(FTBO_F,'v');
Kvel2 = num_F(end)/den_F(end-1);
E_RP2 = 1/Kvel2;
disp(['E RP rampe : ', num2str(E_RP2)])
figure
t = 0:0.01:15;
u_Rampe = t.*ones(size(1));
y0 = lsim(FTBF,u_Rampe,t);
plot(t,u_Rampe-y0')
title('Erreur a une rampe')
ylabel('Erreur (deg)')
xlabel('temps (s)')
grid on

%%%% Une compensation est necessaire pour ameliorer le regime permanent
% il faut diminuer l'erreur en RP

FT = 10;             % Une decade, 10
z_re = -wg_des/FT;
p_re = 0;

% 8 calculer Kr
Kr = 1;
num_r = [1 -z_re];
den_r = [1 -p_re];
Ga_RePh = tf(num_r,den_r);

% 9 verifier le design
figure % lieu des racines
FTBO_F2 = Ga_RePh*FTBO_F;
margin(FTBO_F2)
BW3 = bandwidth(feedback(FTBO_F2,1))
[Gm3,Pm3,Wg3,Wp3] = margin(FTBO_F2)
disp(['PM = ', num2str(Pm3),' deg'])
disp(['GM = ', num2str(20*log10(Gm3)),' dB'])
disp(['Wg = ', num2str(Wp3),' rad/s'])
disp(['BW = ', num2str(BW3),' rad/s'])
%disp('La frequence de traverse est bonne mais pas la PM')

FTBF2 = feedback(FTBO_F2,1);
figure % reponse a echelon
step(FTBF2)
[num2_F, den2_F] = tfdata(FTBO_F2,'v');
Kpos_f = num2_F(end)/den2_F(end);
E_RP2 = 1/(Kpos_f+1);
disp(['E RP echelon : ', num2str(E_RP2)])
figure
t = 0:0.01:15;
u_Rampe = t.*ones(size(1));
y0 = lsim(FTBF2,u_Rampe,t);
plot(t,u_Rampe-y0')
title('Erreur a une rampe')
ylabel('Erreur (deg)')
xlabel('temps (s)')
hold on
plot(t,ones(size(t))*0.0051,'--r')
grid on

