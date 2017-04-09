% Initialisations 

run('SM_4.m')
flag_graph = 0;         % on mets les graphiques

%% SA-8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Pamaretres modifiables
%Poles desirés
delta_wn_des = -20;
delta_zeta = 0.15;
%PI
distance_zero_pdes = 8;
%AbPh
nb_AvPh = 2;
phase_extra = 12;


flag_figures = 0; %0: Pas de figure. 1: Figures.

%% %% Génération des ft de phi
Mp = 5;
ts = 0.030;
tr_10_90 = 0.020;
tp = 0.025;

[num_phi, den_phi] = ss2tf(A_phi,B_phi,C_phi,D_phi_1sortie);
ft_phi = tf(num_phi,den_phi);
ftbf_phi = feedback(ft_phi,1);

%% Conception de l'asservissement
phi_des = atand(-pi/(log(Mp/100)));
zeta_des = cosd(phi_des) + delta_zeta;
% A partir de respectivement ts, tp et tr
wn_1 = 4/(ts*zeta_des);
wn_2 = pi/(tp*sqrt(1-zeta_des^2));
wn_3 = (1 + 1.1*zeta_des + 1.4*zeta_des^2)/tr_10_90;
wn_des = max([wn_1 wn_2 wn_3]) + delta_wn_des;
pdes = -wn_des*zeta_des + 1j*wn_des*sqrt(1-zeta_des^2);

if flag_figures==1
figure
rlocus(ft_phi)
hold on
plot([pdes conj(pdes)],'p')
print('rlocus_phi_non_compense_poles_des','-dpng','-r300')
end

%% analyse PHI non comepnsé
t = linspace(0,0.10,1000);
u = ones(size(t));
y_phi = lsim(ftbf_phi,u,t);

if flag_figures==1
figure
hold
plot(t,y_phi)
plot(t,u,'--k')
title('Réponse à l''échelon de ftbf \phi non compensée')
xlabel('temps (s)')
ylabel('angle (deg)')
ax = [0.657 0.6578+0.0804];
ay = [0.50617 0.50617-0.12169];
annotation('textarrow',ax,ay,'String','diverge ')
print('rep_ech_phi_non_compense','-dpng','-r300')

figure
rlocus(ft_phi)
print('rlocus_phi_non_compense','-dpng','-r300')
end

%% PI
p = 0;
z = real(pdes)/distance_zero_pdes;
num_PI = [1 -z];
den_PI = [1 -p];
ft_PI = tf(num_PI,den_PI);

%% AvPh
p = -1000;
den_AvPh = [1 -p];

angle_a_des = angle((polyval(num_phi,pdes)*polyval(num_PI,pdes))/(polyval(den_phi,pdes)*polyval(den_PI,pdes)*polyval(den_AvPh,pdes)^nb_AvPh))*180/pi-360;
delta_z = (- 180 - angle_a_des + phase_extra)/nb_AvPh;
z = real(pdes) - imag(pdes)/tand(delta_z);
num_AvPh = [1 -z];

ft_AvPh = tf(num_AvPh,den_AvPh);
ft_AvPh = ft_AvPh^nb_AvPh;
[num_AvPh, den_AvPh] = tfdata(ft_AvPh,'v');
Ka_SA8 = abs((polyval(den_phi,pdes)*polyval(den_AvPh,pdes)*polyval(den_PI,pdes))/(polyval(num_AvPh,pdes)*polyval(num_phi,pdes)*polyval(num_PI,pdes)));
ft_AvPh = Ka_SA8*tf(num_AvPh,den_AvPh);

if flag_figures==1
figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_AvPh,1,'s');
K = logspace(-3,2,10000);
rlocus(ft_phi*ft_AvPh,K);
axis([-1000 150 -250 250])
end

%% affichage final
if flag_figures==1
figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_AvPh,1,'s');
rlocus(ft_phi*ft_AvPh,K);
axis([-1000 150 -250 250])
end
ftbo_phi_AvPh_PI = ft_phi*ft_PI*ft_AvPh;
ftbf_phi_AvPh_PI = feedback(ftbo_phi_AvPh_PI,1);
[num_ftbf,den_ftbf] = tfdata(ftbf_phi_AvPh_PI,'v');

t_ech = linspace(0,0.3,1000);
u_ech = ones(size(t_ech));
y_ech = lsim(ftbf_phi_AvPh_PI,u_ech,t_ech);
err_abs_ech = abs(u_ech-y_ech');
t_ech_depass = t_ech(y_ech >= 1.02 | y_ech <= 0.98);
ts_ech = t_ech_depass(end);
mp_ech = (max(y_ech)-1)/1*100;
tp_ech = t_ech(y_ech==max(y_ech));
fprintf('zeta                           : %0.4f sec\n',zeta_des)
fprintf('wn                             : %2.2f rad/s\n',wn_des)
fprintf('Temps de stabilisation echelon : %0.4f sec\n',ts_ech)
fprintf('Depassement max                : %0.3f  %%\n',mp_ech)
fprintf('Temps premier pic              : %0.4f sec\n',t_ech(y_ech == max(y_ech)))

t_10 = t_ech(y_ech >= 0.1);
t_10 = t_10(1);

t_90 = t_ech(y_ech >= 0.9);
t_90 = t_90(1);

fprintf('Temps de montee (10%% - 90%%)    : %0.4f sec\n',t_90-t_10)

if flag_figures==1
figure
plot(t_ech,y_ech)
axis([0 0.3 0 2])

figure
nyquist(ftbo_phi_AvPh_PI);
axis([-10 0 -5 5]);
end

if flag_figures==1
figure
pzmap(ftbf_phi_AvPh_PI);
end

%%%%%%%% SA-9 Asservissement axe z

%% Génération des ft z de la plaque

PM_des = 25;            % deg
wg_des = 185;           % rad/s
eRP = 0.04;             % cas 1 avec un echelon 1 et 0.0004 avec echelon 0.010 

[num_z, den_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie);
ft_z = tf(num_z,den_z);
ftbf_z = feedback(ft_z,1);

%% analyse axe z (hauteur) non compensé

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

%% Conception de l'asservissement

%3 Calculer le gain K_des pour avoir une bonne compensation
[mag, pha] = bode(ft_z,wg_des);
K_des = 1/mag;

[Gm1,Pm1,Wg1,Wp1] = margin(K_des*ft_z);

disp(' ')
disp('Parametres apres ajustement du gain ')
disp(['PM = ', num2str(Pm1),' deg'])
disp(['GM = ', num2str(Gm1),' dB'])
disp(['Wg = ', num2str(Wp1),' rad/s'])
disp('Le regime transitoire est bien ajusté')

% 5 compensation du lieu de bode
ajout_marge = 6;
delta_phi = PM_des - Pm1+ajout_marge; 
 
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
G_AvPh = tf(num_a_Z,den_a_Z)

%10 Verifier que les exigences sont rencontrees
FTBO_F = G_AvPh*ft_z;
FTBF = feedback(FTBO_F,1);
BW2 = bandwidth(feedback(FTBO_F,1));
[Gm2,Pm2,Wg2,Wp2] = margin(FTBO_F);
disp(['PM = ', num2str(Pm2),' deg'])
disp(['GM = ', num2str(Gm2),' dB'])
disp(['Wg = ', num2str(Wp2),' rad/s'])
disp(['BW = ', num2str(BW2),' rad/s'])
disp('La frequence de traverse est bonne')


[num_F, den_F] = tfdata(FTBO_F,'v');
Kvel2 = num_F(end)/den_F(end-1);
E_RP2 = 1/Kvel2;
disp(['E RP rampe : ', num2str(E_RP2)])

%% RePh Une compensation est necessaire pour ameliorer le regime permanent
% il faut diminuer l'erreur en RP

%1 Determination du Kvel_des
Kpos = num_z(end)/den_z(end);
Kpos_des = 1/eRP -1;
% 2 Trouver le gain desire aux basses frequences
K2_des = Kpos_des/Kpos;

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
FTBO_F2 = G_RePh*FTBO_F;
BW3 = bandwidth(feedback(FTBO_F2,1));
[Gm3,Pm3,Wg3,Wp3] = margin(FTBO_F2);
disp(['PM = ', num2str(Pm3),' deg'])
disp(['GM = ', num2str(20*log10(Gm3)),' dB'])
disp(['Wg = ', num2str(Wp3),' rad/s'])
disp(['BW = ', num2str(BW3),' rad/s'])
%disp('La frequence de traverse est bonne mais pas la PM')

FTBF2 = feedback(FTBO_F2,1);
[num2_F, den2_F] = tfdata(FTBO_F2,'v');
Kpos_f = num2_F(end)/den2_F(end);
E_RP2 = 1/(Kpos_f+1);
disp(['E RP echelon : ', num2str(E_RP2)])

zeta_z = 1/2*sqrt(tand(PM_des)*sind(PM_des))
Mp_z = 100*exp(-pi*zeta_z/sqrt(1-zeta_z^2));

%% SA-10 
%%%%% SA-10 : position Sphere x et y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Légende 
% FT_XX -> fonction de transfert position X / angle theta
% FT_XV -> fonction de transfert vitesse X / angle theta
% FT_YY -> fonction de transfert position Y / angle phi
% FT_YV -> fonction de transfert vitesse Y / angle phi

% criteres de performances
ts = 2;
zeta = 0.9;
wn = 4/(ts*zeta);
phi_des = cosd(zeta);
p_des = -wn*zeta + 1j*wn*sqrt(1-zeta^2)

[num_Sx, den_Sx] = ss2tf(AxS,BxS,CxS,DxS);
disp('Analyse préliminaire')
disp('FT position X / angle theta')
FT_XX = tf(num_Sx(1,:),den_Sx)

% reponse a echelon
FTBF_XX = feedback(FT_XX,1);

%% Compensation AvPh pour corriger le regime transitoire

delta_phi = 180 - angle(polyval(num_Sx(1,:),p_des)/polyval(den_Sx,p_des))*180/pi;
phi_z = delta_phi;
z = real(p_des) - imag(p_des)/tand(phi_z);
num_a_XX = [1 -z];
den_a_XX = [0 1];

FTa_XX = tf(num_a_XX,den_a_XX)
Kv_XX = 1/abs(polyval(conv(num_a_XX,num_Sx(1,:)),p_des)/polyval(conv(den_a_XX,den_Sx),p_des));
Kp_XX = -z*Kv_XX;

%% SA-10 y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Légende 
% FT_XX -> fonction de transfert position X / angle theta
% FT_XV -> fonction de transfert vitesse X / angle theta
% FT_YY -> fonction de transfert position Y / angle phi
% FT_YV -> fonction de transfert vitesse Y / angle phi

% criteres de performances
ts = 2;
zeta = 0.9;
wn = 4/(ts*zeta);
phi_des = acosd(zeta);
p_des = -wn*zeta + 1j*wn*sqrt(1-zeta^2);

[num_Sy, den_Sy] = ss2tf(AyS,ByS,CyS,DyS);

disp('Analyse préliminaire')
disp('FT position y / angle phi')
FT_YY = tf(num_Sy(1,:),den_Sy)

figure
rlocus(FT_YY)
axis([-3 1.5 -1 1])
hold on
plot(real(p_des),imag(p_des),'p')
plot(real(p_des),-imag(p_des),'p')
title('Lieu des racines pour position Y / \phi')
print('Lieu_racines_non_compense_FT_YY','-dpng','-r450')

% reponse a l'echelon
FTBF_YY = feedback(FT_YY,1);
t = linspace(0,25,3000);
u = ones(size(t));
y = lsim(FTBF_YY,u,t);
figure
subplot(2,1,1)
plot(t,y)
title('Réponse a l''échelon')
xlabel('Temps (s)')
ylabel('Amplitude')


subplot(2,1,2)
plot(t,y)
title('Réponse a l''échelon (zoom)')
xlabel('Temps (s)')
ylabel('Amplitude')
axis([0 0.5 -0.5 0.2])
print('reponse_impulsionnelle_non_compense_FT_XX','-dpng','-r450')

disp('Marginalement stable, une compensation est nécessaire')

%% compensation PD pour amléliorer le regime transitoire

delta_phi = 180 - angle(polyval(num_Sy(1,:),p_des)/polyval(den_Sy,p_des))*180/pi;
phi_z = delta_phi;
z = real(p_des) - imag(p_des)/tand(phi_z);
num_a_YY = [1 -z];
den_a_YY = [0 1];

Kv_YY = 1/abs(polyval(conv(num_a_YY,num_Sy(1,:)),p_des)/polyval(conv(den_a_YY,den_Sy),p_des));
Kp_YY = -z*Kv_YY;




%%  Graphique

if flag_graph == 1
    %Graphique 1 : réponse initiale à l'échelon
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
    
    % Graphique 2 : lieu des racines initials pour le z non compensé
    figure 
    rlocus(ft_z)
    title('Lieu des racines pour ft z de la plaque')
    print('rlocus_z_non_compense','-dpng','-r300')
  
    % Graphique 3 : Bode de la fonction initiale
    figure
    margin(ft_z)
    
    % graphique 4 : Bode 
    figure
    margin(K_des*ft_z)
    print('bode_z_non_compense_gain_k_des','-dpng','-r300')
    
    % graphique 5 : bode avec compensation AvPh
    figure
    margin(FTBO_F)
    print('bode_z_AvPh','-dpng','-r300')
    
    figure % reponse a echelon
    step(FTBF)
    title('Reponse à l''échelon')
    
    figure
    t = 0:0.01:15;
    u_Rampe = t.*ones(size(1));
    y0 = lsim(FTBF,u_Rampe,t);
    plot(t,u_Rampe-y0')
    title('Erreur a une rampe')
    ylabel('Erreur (deg)')
    xlabel('temps (s)')
    grid on
    
    figure
    margin(K2_des*FTBO_F)
    print('bode_z_AvPh_k_des','-dpng','-r300')
    
    figure % lieu des racines
    margin(FTBO_F2)
    print('bode_z_AvPh_RePh','-dpng','-r450')
   
    figure % reponse a echelon
    step(FTBF2)
    
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

    figure
    rlocus(FTBO_F2)
    pole_z = rlocus(FTBO_F2,1)
    hold on
    plot(real(pole_z),imag(pole_z),'p')
    
    figure
    rlocus(FT_XX)
    axis([-3 1.5 -1 1])
    hold on
    plot(real(p_des),imag(p_des),'p')
    plot(real(p_des),-imag(p_des),'p')
    title('Lieu des racines pour ')
    print('Lieu_racines_non_compense_FT_XX','-dpng','-r450')
    
    t = linspace(0,25,3000);
    u = ones(size(t));
    y = lsim(FTBF_XX,u,t);
    figure
    subplot(2,1,1)
    plot(t,y)
    title('Réponse a l''impulsion')
    xlabel('Temps (s)')
    ylabel('Amplitude')
    axis([0 25 -2*1e26 2*1*26])

    subplot(2,1,2)
    plot(t,y)
    title('Réponse a l''impulsion (zoom)')
    xlabel('Temps (s)')
    ylabel('Amplitude')
    axis([0 0.5 -0.5 0.2])
    print('reponse_impulsionnelle_non_compense_FT_XX','-dpng','-r450')
    disp('Diverge, une compensation est nécessaire')
    
    
end
    
  
  


