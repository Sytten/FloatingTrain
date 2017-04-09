% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-02
% Description du programme : Asservissement

%% Génération des ft z de la plaque
run('SM_4.m')

PM_des = 25;            % deg
wg_des = 185;           % rad/s
eRP = 0.04;             % cas 1 avec un echelon 1 et 0.0004 avec echelon 0.010 

[num_z, den_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie);
ft_z = tf(num_z,den_z);
ftbf_z = feedback(ft_z,1);

%% analyse axe z (hauteur) non compensé
t = linspace(0,0.50,5000);
u = ones(size(t));
y_z = lsim(ftbf_z,u,t);
figure
plot(t,y_z)
hold on;
plot(t,u,'--k')
title('Réponse à l''échelon de ftbf z non compensée')
xlabel('temps (s)')
ylabel('angle (deg)')
axis([0 0.5 0 1.2])
print('rep_ech_z_non_compense','-dpng','-r300')
Kpos_ini = num_z(end)/den_z(end);
erreur_ech_ini = 1/(1+Kpos_ini);
[Gm_ini,Pm_ini,Wg_ini,Wp_ini] = margin(ft_z);
disp('Section 1 : Analyse initiale')
disp(['PM = ', num2str(Pm_ini),' deg'])
disp(['GM = ', num2str(Gm_ini),' dB'])
disp(['Wg = ', num2str(Wp_ini),' rad/s'])
disp(['Erreur initiale ', num2str(erreur_ech_ini),' Erreur désirée à l''échelon (cas 1) : ',num2str(eRP)])
disp('On ne rencontre pas les criteres de performance')
disp('Un asservissement est nécessaire pour corriger l''erreur')
figure
rlocus(ft_z)
title('Lieu des racines pour ft z de la plaque')
print('rlocus_z_non_compense','-dpng','-r450')

%% Conception de l'asservissement

%2 dessiner le diagramme de bode sans com;pensation
figure
margin(ft_z)

%3 Calculer le gain K_des pour avoir une bonne compensation
[mag, pha] = bode(ft_z,wg_des);
K_des = 1/mag;
%4 dessiner le lieu de bode avec le gain K_des
figure
margin(K_des*ft_z)
print('bode_z_non_compense_gain_k_des','-dpng','-r450')
[Gm1,Pm1,Wg1,Wp1] = margin(K_des*ft_z);

disp(' ')
disp('Parametres apres ajustement du gain ')
disp(['PM = ', num2str(Pm1),' deg'])
disp(['GM = ', num2str(Gm1),' dB'])
disp(['Wg = ', num2str(Wp1),' rad/s'])
disp('Le regime transitoire est bien ajusté')

% 5 compensation du lieu de bode
delta_phi = PM_des - Pm1+5; %17
 
%6 calcul du parametre alpha
alpha = (1-sind(delta_phi))/(1+sind(delta_phi));

%7 calcul du parametre T
T = 1/(wg_des*sqrt(alpha));

%8 calculer les frequence de coupure
z = -1/T;
p = -1/(alpha*T);

%9 calcul du gain Ka
Ka_Z = K_des/sqrt(alpha);
num_a_Z = Ka_Z*[1 -z];
den_a_Z = [1 -p];
G_AvPh = tf(num_a_Z,den_a_Z); 
              % On retire le gain

%10 Verifier que les exigences sont rencontrees
figure
FTBO_F = G_AvPh*ft_z;
FTBF = feedback(FTBO_F,1);
margin(FTBO_F)
print('bode_z_AvPh','-dpng','-r450')
BW2 = bandwidth(feedback(FTBO_F,1));
[Gm2,Pm2,Wg2,Wp2] = margin(FTBO_F);
disp(['PM = ', num2str(Pm2),' deg'])
disp(['GM = ', num2str(Gm2),' dB'])
disp(['Wg = ', num2str(Wp2),' rad/s'])
disp(['BW = ', num2str(BW2),' rad/s'])
disp('La frequence de traverse est bonne')

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

%% RePh Une compensation est necessaire pour ameliorer le regime permanent
% il faut diminuer l'erreur en RP

%1 Determination du Kvel_des
Kpos = num_z(end)/den_z(end);
Kpos_des = 1/eRP -1;
% 2 Trouver le gain desire aux basses frequences
K2_des = Kpos_des/Kpos;

% 3 Utiliser une compensateur a retard

% 4 Dessiner le lieu de bode avec le gain K_des
figure
margin(K2_des*FTBO_F)
print('bode_z_AvPh_k_des','-dpng','-r450')

%5 On trouve le gain
beta = K2_des;

% 6 Placer 0 du compensateur

% 7 0 et z
FT = 10;             % Une decade, 10
z_re = -wg_des/FT;
p_re = -wg_des/(FT*beta);

% 8 calculer Kr
Kr = K2_des/beta;
num_r_Z = [1 -z_re];
den_r_Z = [1 -p_re];
G_RePh = tf(num_r_Z,den_r_Z)

% 9 verifier le design
figure % lieu des racines
FTBO_F2 = G_RePh*FTBO_F;
margin(FTBO_F2)
print('bode_z_AvPh_RePh','-dpng','-r450')
BW3 = bandwidth(feedback(FTBO_F2,1));
[Gm3,Pm3,Wg3,Wp3] = margin(FTBO_F2);
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

zeta_z = 1/2*sqrt(tand(PM_des)*sind(PM_des))
Mp_z = 100*exp(-pi*zeta_z/sqrt(1-zeta_z^2));
figure
rlocus(FTBO_F2)
pole_z = rlocus(FTBO_F2,1)
hold on
plot(real(pole_z),imag(pole_z),'p')
