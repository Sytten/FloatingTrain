% Auteur : Louis D'Amour
% Date de création : 23 mars 2017
% Date d'édition : 23 mars 2017
% Description du programme : Fonction calculant les courants à l'équilibre


function i_eq = equilibrium(z_eq, Ax, Ay, Px_eq, Py_eq, masseS)
% EQUILIBRIUM Calcul les courants à l'équilibre des actionneurs.
%   [i_eqA, i_eqB, i_eqC] = EQUILIBRIUM(Z) calcule les courants pour une
%   plaque horizontale et sans bille.
%   [i_eqA, i_eqB, i_eqC] = EQUILIBRIUM(Z, PHI, THETA) calcule les courants pour une
%   plaque avec un angle et sans bille.
%   [i_eqA, i_eqB, i_eqC] = EQUILIBRIUM(Z, PHI, THETA, XS, YS, MS) calcule les courants pour une
%   plaque avec un angle et avec une bille.
%   [i_eqA, i_eqB, i_eqC] = EQUILIBRIUM(Z, 0, 0, XS, YS, MS) calcule les courants pour une
%   plaque horizontale et avec une bille.
%
% Fonction réalisée dans le but d'accomplir la tâche SS-2 du projet S4H17
% pour l'équipe P01.


switch nargin
    case 1
        Ax = 0;
        Ay = 0;
        Px_eq = 0;
        Py_eq = 0;
        masseS = 0;
    case 3
        Px_eq = 0;
        Py_eq = 0;
        masseS = 0;
end

% Constantes

g = 9.81;
masseP = 0.425;
r_abc = 95.2e-3;
be1 = 13.029359254409743;
as0 = 0.0586667067;
as1 = 22.41055234;
as2 = 860.3941759;
as3 = 233710.9087;
ae0 = 1.325400315;
ae1 = 366.4392052;
ae2 = -30.42916186;
ae3 = 787041.4323;
XA = r_abc;
XB = -r_abc*sind(30);
XC = -r_abc*sind(30);
YA = 0;
YB = r_abc*cosd(30);
YC = -r_abc*cosd(30);

% Calculs

Fc_eq = (-masseP*g - masseS.*g + (3.*masseS.*g.*Py_eq)/(2*r_abc*sind(60)) + (masseS.*g.*Px_eq)/(r_abc))/3; % Q1 (equation 8 dans SS-1)
Fb_eq = Fc_eq - (masseS.*g.*Py_eq)/(r_abc*sind(60)); % Q3
Fa_eq = (2.*Fc_eq - (masseS.*g.*Py_eq)/(r_abc*sind(60))).*cosd(60) - (masseS.*g.*Px_eq)/(r_abc); % Q5
F_eq = [Fa_eq; Fb_eq; Fc_eq];

zc_eq = YC.*Ax - XC.*Ay + z_eq;
zb_eq = YB.*Ax - XB.*Ay + z_eq;
za_eq = YA.*Ax - XA.*Ay + z_eq;
z_abc = [za_eq; zb_eq; zc_eq];

F_s = (-1)./(as0 + as1.*z_abc + as2*z_abc.^2 + as3*z_abc.^3); % Force F_s
F_e_den = ae0 + ae1*z_abc + ae2*z_abc.^2 + ae3*z_abc.^3;      % Force F_e (dénominateur)

abs_i_eq(:,1) = (-be1 - sqrt(be1^2 - 4.*(F_eq - F_s).*F_e_den))./2; % i_eq est négatif
abs_i_eq(:,2) = (-be1 + sqrt(be1^2 + 4.*(F_eq - F_s).*F_e_den))./2; % i_eq est positif
abs_i_eq(:,3) = (-be1 + sqrt(be1^2 - 4.*(F_eq - F_s).*F_e_den))./2; % i_eq est négatif
abs_i_eq(:,4) = (-be1 - sqrt(be1^2 + 4.*(F_eq - F_s).*F_e_den))./2; % i_eq est positif


abs_i_eq(abs_i_eq < 0) = 0;
sign = [-1 1 -1 1];
sign = repmat(sign, 3, 1);
abs_i_eq = sign.*abs_i_eq;

% Sorties

i_eq = sum(abs_i_eq, 2);


end
