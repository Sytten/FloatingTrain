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
margin(K2_des*ft_z)

%5 On trouve le gain
beta = K2_des;

% 6 Placer 0 du compensateur

% 7 0 et z
FT = 10;             % Une decade, 10
z_re = -wg_des/FT;
p_re = -wg_des/(FT*beta);

% 8 calculer Kr
Kr = K2_des/beta;
num_r = [1 -z_re];
den_r = [1 -p_re];
G_RePh = tf(num_r,den_r)

% 9 verifier le design
figure % lieu des racines
FTBO_F2 = G_RePh*ft_z;
margin(FTBO_F2)
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
