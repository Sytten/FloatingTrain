% Auteur : Louis D'Amour
% Date de création : 2017-04-10
% Date d'édition : 2017-04-10
% Description du programme : Asservissement SA-9 (Cas 2)

% Obtention de la fonction de transfert de départ
[num_ini, den_ini] = ss2tf(A_z, B_z, C_z, D_z_1sortie);
FT_INI = tf(num_ini, den_ini);
flag_SA9 = 0;
%%% CONCEPTION D'UN DOUBLE AVANCE DE PHASE AVEC BODE (MÉTHODE 1) %%%

% Critères de conception (ÉTAPE 1)
PM_des = 25; %degrées    -    (Marge de phase désirée)
wg_des = 185; %rad/s    -    (Fréquence de traverse en gain désirée)
err_echelon = 0; %m      -    (Erreur à l'infini à une consigne échelon)

% Lieu des racines de la fonction de transfert initiale sans compensation
if flag_SA9 == 1
    figure(1)
    rlocus(FT_INI)
    xlabel('Réels')
    ylabel('Imaginaires')
    title('Lieu des racines de la fonction de transfert initiale non compensée')
end
% Lieu de Bode de la fonction de transfet initiale sans compensation (ÉTAPE 2)
[GM_lin, PM, ftp, ftg] = margin(FT_INI);
GM_db = 20*log10(GM_lin);

if flag_SA9 == 1
figure(2)
margin(FT_INI)
xlabel('Fréquence')
title([sprintf('Diagramme de Bode de la fonction de transfert non compensée\nPM: '),...
    num2str(PM), '° (', num2str(ftg), 'rad/s) GM: ', num2str(GM_db), ' dB (', num2str(ftp), ' rad/s)'])
end
% Calcul du gain K* pour obtenir le wg_des (ÉTAPE 3)
[gain_at_wg_des, ~]  = bode(FT_INI, wg_des);
gain_at_wg_des_db = 20*log10(gain_at_wg_des);
K_des = 10^(-gain_at_wg_des_db/20);

% Lieu de Bode de la fonction initiale avec un gain K* (ÉTAPE 4)
[GM_lin, PM, ftp, ftg] = margin(K_des*FT_INI);
GM_db = 20*log10(GM_lin);

if flag_SA9 == 1
figure(3)
margin(FT_INI)
hold on
margin(K_des*FT_INI)
xlabel('Fréquence')
title([sprintf('Diagramme de Bode de la fonction de transfert avec gain K*\nPM: '),...
    num2str(PM), '° (', num2str(ftg), 'rad/s) GM: ', num2str(GM_db), ' dB (', num2str(ftp), ' rad/s)'])
legend('FT iniitale', 'K_des * FT initiale')
end
% Avance de phase nécessaire delta_phi (ÉTAPE 5)
delta_phi = PM_des - PM + 5;
% Comme le delta_phi est plus grand que 90°, il faut concevoir un double
% avance de phase
delta_phi = delta_phi/2;
% Calcul du paramètre alpha (ÉTAPE 6)
alpha = (1 - sind(delta_phi))/(1 + sind(delta_phi));

% Calcul du paramètre T (ÉTAPE 7)
T = 1/(wg_des*sqrt(alpha));

% Calcul des pôles et zéros (ÉTAPE 8)
z = -1/T;
p = -1/(alpha*T);

% Calcul du gain Ka (ÉTAPE 9)
Ka = K_des/alpha;   % La formule dit K_des/sqrt(alpha) mais on design un double AvPh

% Fonction de transfert du compensateur
AVPH = Ka*tf([1 -z], [1 -p])*tf([1 -z], [1 -p]);

% Lieu de Bode de la fonction de transfert compensée par deux avances de
% phase (ÉTAPE 10)
[GM_lin, PM, ftp, ftg] = margin(AVPH*FT_INI);
GM_db = 20*log10(GM_lin);
if flag_SA9 == 1
figure(4)
margin(FT_INI)
hold on
margin(K_des*FT_INI)
margin(AVPH*FT_INI)
xlabel('Fréquence')
title([sprintf('Diagramme de Bode de la fonction de transfert compensée par deux avances de phase\nPM: '),...
    num2str(PM), '° (', num2str(ftg), 'rad/s) GM: ', num2str(GM_db), ' dB (', num2str(ftp), ' rad/s)'])
legend('FT initiale', 'K_des * FT initiale', 'FT avec AVPH')
end

%%% CONCEPTION D'UN PI AVEC BODE (Classique) %%%

% Obtention de la fonction de transfert intermédiaire
FT_INTER = AVPH*FT_INI;

% Calcul du zéro (ÉTAPE 3)
z = -wg_des/10;

% Calcul du pôle (Pour respecter le critère de Nyquist)
p = -1e-15;

% Fonction de transfert du compensateur
PI = tf([1 -z], [1 -p]);

% Lieu de Bode de la fonction de transfert compensée par deux avances de
% phase et un PI
[GM_lin, PM, ftp, ftg] = margin(PI*AVPH*FT_INI);
GM_db = 20*log10(GM_lin);
if flag_SA9 == 1
figure(5)
margin(FT_INI)
hold on
margin(K_des*FT_INI)
margin(AVPH*FT_INI)
margin(PI*AVPH*FT_INI)
xlabel('Fréquence')
title([sprintf('Diagramme de Bode de la fonction de transfert compensée finale\nPM: '),...
    num2str(PM), '° (', num2str(ftg), 'rad/s) GM: ', num2str(GM_db), ' dB (', num2str(ftp), ' rad/s)'])
legend('FT initiale', 'K_des * FT initiale', 'FT avec AVPH','FT finale')

% Critère de Nyquist

figure(6)
nyquist(PI*AVPH*FT_INI)
xlabel('Réels')
ylabel('Imaginaires')
title('Diagramme de Nyquist de la fonction de transfert finale')
ylim([-6 6])
end
% Réponse à une consigne échelon
FT_FIN_FB = feedback(PI*AVPH*FT_INI, 1);
t = linspace(0, 0.6, 1000);
u = ones(size(t));
y = lsim(FT_FIN_FB, u, t);
if flag_SA9 == 1
figure(7)
plot(t, y)
hold on
plot(t, u, '--')
xlabel('Temps (s)')
ylabel('Hauteur (m)')
title('Réponse à une consigne échelon de la fonction de transfert compensée')
end