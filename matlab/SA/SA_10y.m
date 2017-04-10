% Auteur : Pierre-Charles Gendron
% Date de création : 2017-04-08
% Date d'édition : 2017-04-10
% Description du programme : Asservissement de la position y et vitesse 

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

if flag_figures==1
    
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

end;
%% compensation PD pour amléliorer le regime transitoire

delta_phi = 180 - angle(polyval(num_Sy(1,:),p_des)/polyval(den_Sy,p_des))*180/pi;
phi_z = delta_phi;
z = real(p_des) - imag(p_des)/tand(phi_z);
num_a_YY = [1 -z];
den_a_YY = [0 1];

Kv_YY = 1/abs(polyval(conv(num_a_YY,num_Sy(1,:)),p_des)/polyval(conv(den_a_YY,den_Sy),p_des));
Kp_YY = -z*Kv_YY;

%% axe x

[num_Sx, den_Sx] = ss2tf(AxS,BxS,CxS,DxS);
FT_XX = tf(num_Sx(2,:),den_Sx);

delta_phi = 180 - angle(polyval(num_Sx(1,:),p_des)/polyval(den_Sx,p_des))*180/pi;
phi_z = delta_phi;
z = real(p_des) - imag(p_des)/tand(phi_z);
num_a_XX = [1 -z];
den_a_XX = [0 1];

Kv_XX = 1/abs(polyval(conv(num_a_XX,num_Sx(1,:)),p_des)/polyval(conv(den_a_XX,den_Sx),p_des));
Kp_XX = -z*Kv_XX;
