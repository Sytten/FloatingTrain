% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-10
% Description du programme : Asservissement SA-9 cas 1


%% Parametres modifiables
flag_graph = 0;         % 0 pas de figure 1 figure
mrg = 5;                % on surcompense pour le retard de phase
%% Génération des ft z de la plaque
PM_des = 25;            % deg
wg_des = 185;           % rad/s
eRP = -0.04;             % cas 1 avec un echelon 1 et 0.0004 avec echelon 0.010 

[num_z, den_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie);
ft_z = tf(num_z,den_z);
ftbf_z = feedback(ft_z,1);

%% analyse axe z (hauteur) non compensé

if flag_graph ==1
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
end

Kpos_ini = num_z(end)/den_z(end);
erreur_ech_ini = 1/(1+Kpos_ini);
[Gm_ini,Pm_ini,Wg_ini,Wp_ini] = margin(ft_z);

if flag_graph ==1
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
end

%% conception AvPh

[mag, ~] = bode(ft_z,wg_des);
K_des = 1/mag;

% bode de la fonction ft_z avec gain*
if flag_graph ==1
figure
margin(K_des*ft_z)
end
[Gm,Pm,Wg,Wp] = margin(K_des*ft_z);

delta_phi = PM_des - Pm + mrg;
delta_phi = delta_phi/2;
alf = (1-sind(delta_phi))/(1+sind(delta_phi));
T_av_SA91 = 1/(wg_des*sqrt(alf));
z_av_SA91 = -1/T_av_SA91;
p_av_SA91 = -1/(alf*T_av_SA91);
num_av_SA91 = [1 -z_av_SA91];
den_av_SA91 = [1 -p_av_SA91];
ft_av_SA91 = tf(num_av_SA91,den_av_SA91);
Ka_av_SA91 = K_des/alf;
ft_z_av_SA91 = Ka_av_SA91*ft_av_SA91*ft_av_SA91;

if flag_graph ==1
    figure
    margin(ft_z_av_SA91*ft_z)
end

%% RePh

[num_h,den_h] = tfdata(ft_z_av_SA91*ft_z,'v');
Kpos_now = num_h(end)/den_h(end);
eRP_now = 1/(Kpos_now+1);           % pour valider l'erreur en régime permanent

Kpos_des = 1/eRP -1;
K_des = Kpos_des/Kpos_now;

if flag_graph ==1
    figure
    margin(K_des*ft_z_av_SA91*ft_z)
end


[beta, pha] = bode(K_des*ft_z_av_SA91*ft_z,wg_des);
T = 10/wg_des;
z_re_SA91 = -1/T;
p_re_SA91 = -1/(beta*T);
num_re_SA91 = [1 -z_re_SA91];
den_re_SA91 = [1 -p_re_SA91];
Kr_SA91 = K_des/beta;
ft_z_re_SA91 = tf(Kr_SA91*num_re_SA91,den_re_SA91);

if flag_graph ==1
    figure
    margin(ft_z_re_SA91*ft_z_av_SA91*ft_z)
    figure
    nyquist(ft_z_re_SA91*ft_z_av_SA91*ft_z)
end
% erreur regime permanent
[num_h,den_h] = tfdata(ft_z_re_SA91*ft_z_av_SA91*ft_z,'v');
Kpos_now = num_h(end)/den_h(end);
eRP_now = 1/(Kpos_now+1);

