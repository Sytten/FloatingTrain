% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-10
% Description du programme : Asservissement SA-8


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

[num_theta, den_theta] = ss2tf(A_theta,B_theta,C_theta,D_theta_1sortie);
ft_theta = tf(num_theta,den_theta);

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
p = -1E-8;
z = real(pdes)/distance_zero_pdes;
num_PI_SA8 = [1 -z];
den_PI_SA8 = [1 -p];
ft_PI_SA8 = tf(num_PI_SA8,den_PI_SA8);

%% AvPh
p = -1000;
den_AvPh_SA8 = [1 -p];

angle_a_des = angle((polyval(num_phi,pdes)*polyval(num_PI_SA8,pdes))/(polyval(den_phi,pdes)*polyval(den_PI_SA8,pdes)*polyval(den_AvPh_SA8,pdes)^nb_AvPh))*180/pi-360;
delta_z = (- 180 - angle_a_des + phase_extra)/nb_AvPh;
z = real(pdes) - imag(pdes)/tand(delta_z);
num_AvPh_SA8 = [1 -z];

ft_AvPh_SA8 = tf(num_AvPh_SA8,den_AvPh_SA8);
ft_AvPh_SA8 = ft_AvPh_SA8^nb_AvPh;
[num_AvPh_SA8, den_AvPh_SA8] = tfdata(ft_AvPh_SA8,'v');
Ka_SA8 = abs((polyval(den_phi,pdes)*polyval(den_AvPh_SA8,pdes)*polyval(den_PI_SA8,pdes))/(polyval(num_AvPh_SA8,pdes)*polyval(num_phi,pdes)*polyval(num_PI_SA8,pdes)));
ft_AvPh_SA8 = Ka_SA8*tf(num_AvPh_SA8,den_AvPh_SA8);

if flag_figures==1
figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_PI_SA8*ft_AvPh_SA8,1,'s');
K = logspace(-3,2,10000);
rlocus(ft_phi*ft_PI_SA8*ft_AvPh_SA8,K);
axis([-1000 150 -250 250])
end

%% affichage final
if flag_figures==1
figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_AvPh_SA8*ft_PI_SA8,1,'s');
rlocus(ft_phi*ft_AvPh_SA8*ft_PI_SA8,K);
axis([-1000 150 -250 250])
end
ftbo_phi_AvPh_PI = ft_phi*ft_PI_SA8*ft_AvPh_SA8;
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