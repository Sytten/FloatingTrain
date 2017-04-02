% Auteur : Pierre-Charles Gendron et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-02
% Description du programme : Asservissement
clc
close all
clear all


%% Génération des ft de phi
run('SM_4.m')

Mp = 5;
ts = 0.030;
tr_10_90 = 0.020;
tp = 0.025;

[num_phi, den_phi] = ss2tf(A_phi,B_phi,C_phi,D_phi_1sortie);
ft_phi = tf(num_phi,den_phi);
ftbf_phi = feedback(ft_phi,1);


%% analyse PHI non comepnsé
t = linspace(0,0.10,1000);
u = ones(size(t));
y_phi = lsim(ftbf_phi,u,t);
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

%% Conception de l'asservissement
phi_des = atand(-pi/(log(Mp/100)));
zeta_des = cosd(phi_des);

% A partir de respectivement ts, tp et tr
wn_1 = 4/(ts*zeta_des);
wn_2 = pi/(tp*sqrt(1-zeta_des^2));
wn_3 = (1 + 1.1*zeta_des + 1.4*zeta_des^2)/tr_10_90;
wn_des = max([wn_1 wn_2 wn_3]);
pdes = -wn_des*zeta_des + 1j*wn_des*sqrt(1-zeta_des^2);

figure
rlocus(ft_phi)
hold on
plot([pdes conj(pdes)],'p')
print('rlocus_phi_non_compense_poles_des','-dpng','-r300')


%% RePh avec zéro sur le pole à droite et

poles_ftbo_phi = roots(den_phi);
z = poles_ftbo_phi(1);
p = real(pdes)*2;
num_RePh = [1 -z];
den_RePh = [1 -p];
ft_RePh = tf(num_RePh,den_RePh);
ft_phi = ft_phi*ft_RePh;
[num_phi, den_phi] = tfdata(ft_phi,'v');

%% AvPh
nb_AvPh = 2;
phase_extra = 5;

angle_a_des = angle(polyval(num_phi,pdes)/polyval(den_phi,pdes))*180/pi-360;
delta_phi = (- 180 - angle_a_des + phase_extra)/nb_AvPh;
alpha = 180 - phi_des;
phi_z = (alpha + delta_phi)/2;
phi_p = (alpha - delta_phi)/2;
z = real(pdes) - imag(pdes)/tand(phi_z);
p = real(pdes) - imag(pdes)/tand(phi_p);
num_AvPh = [1 -z];
den_AvPh = [1 -p];
ft_AvPh = tf(num_AvPh,den_AvPh);
ft_AvPh = ft_AvPh^nb_AvPh;
[num_AvPh, den_AvPh] = tfdata(ft_AvPh,'v');
Ka = abs(polyval(den_phi,pdes)*polyval(den_AvPh,pdes)/(polyval(num_AvPh,pdes)*polyval(num_phi,pdes)));
ft_AvPh = Ka*tf(num_AvPh,den_AvPh);

figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_AvPh,1,'s');
rlocus(ft_phi*ft_AvPh);
axis([-1000 150 -250 250])

%% PI
p = 0;
z = real(pdes)/10;
ft_PI = tf([1 -z],[1 -p]);

%% affichage final
figure
hold
plot([pdes conj(pdes)],'p');
rlocus(ft_phi*ft_AvPh*ft_PI,1,'s');
rlocus(ft_phi*ft_AvPh*ft_PI);
axis([-200 150 -250 250])

ftbf_phi_AvPh = feedback(ft_phi*ft_AvPh*ft_PI,1);

t_ech = linspace(0,0.3,1000);
u_ech = ones(size(t_ech));
y_ech = lsim(ftbf_phi_AvPh,u_ech,t_ech);
err_abs_ech = abs(u_ech-y_ech');
t_ech_depass = t_ech(y_ech >= 1.02 | y_ech <= 0.98);
ts_ech = t_ech_depass(end);
mp_ech = (max(y_ech)-1)/1*100;
tp_ech = t_ech(y_ech==max(y_ech));
fprintf('Temps de stabilisation echelon: %0.4f sec\n',ts_ech)
fprintf('Depassement max: %0.2f%%\n',mp_ech)
t_10 = t_ech(y_ech >= 0.1);
t_10 = t_10(1);

t_90 = t_ech(y_ech >= 0.9);
t_90 = t_90(1);

t_100 = t_ech(y_ech >= 1);
t_100 = t_100(1);

fprintf('Temps de montee (10%% - 90%%): %0.4f sec\n',t_90-t_10)
fprintf('Temps de montee (0%% - 100%%): %0.4f sec\n',t_100)

figure
plot(t_ech,y_ech)
axis([0 0.3 0 2])