% Auteur : Pierre-Charles Gendron, Antoine Mailhot et Hugo Therrien
% Date de création : 2017-04-02
% Date d'édition : 2017-04-10
% Description du programme : Asservissement de la position x et vitesse x

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
p_des = -wn*zeta + 1j*wn*sqrt(1-zeta^2);

[num_Sx, den_Sx] = ss2tf(AxS,BxS,CxS,DxS);
disp('Analyse préliminaire')
disp('FT position X / angle theta')
FT_XX = tf(num_Sx(1,:),den_Sx)

if flag_figures==1
    
figure
rlocus(FT_XX)
axis([-3 1.5 -1 1])
hold on
plot(real(p_des),imag(p_des),'p')
plot(real(p_des),-imag(p_des),'p')
title('Lieu des racines pour ')
print('Lieu_racines_non_compense_FT_XX','-dpng','-r450')

% reponse a echelon
FTBF_XX = feedback(FT_XX,1);
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
%% Compensation AvPh pour corriger le regime transitoire

delta_phi = 180 - angle(polyval(num_Sx(1,:),p_des)/polyval(den_Sx,p_des))*180/pi;
phi_z = delta_phi;
z = real(p_des) - imag(p_des)/tand(phi_z);
num_a_XX = [1 -z];
den_a_XX = [0 1];

Kv_XX = 1/abs(polyval(conv(num_a_XX,num_Sx(1,:)),p_des)/polyval(conv(den_a_XX,den_Sx),p_des));
Kp_XX = -z*Kv_XX;