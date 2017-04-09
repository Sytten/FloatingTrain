function [M, O] = interpolation(N, V, T)

pas = 101; % Pas integration

[coeff] = polyfit(N(1,:),N(2,:),length(N)-1);
dx = (N(1,end)-N(1,1))/pas;
x = N(1,1):dx:N(1,end);
M = [x; polyval(coeff, x)];

% calcul longueur & erreur
coeff_d = polyder(coeff); % f'
x_d = polyval(coeff_d, x);
longueur = sqrt(1 + x_d.^2); % g
L = trapz(x, longueur);

coeff_d2 = polyder(coeff_d); % f''
x_d2 = polyval(coeff_d2, x);
longueur_d = x_d.*x_d2./longueur; %g'
E = dx^2/2*(longueur_d(end)-longueur_d(1));

% vitesse reelle
O_taille = ceil(L/(T*V));
Vreel = L/(T*O_taille);

% distance entre chaque point
d = L/O_taille;

O = [];
Ltr = [0];
xi = 1;
O = [xi];
for i = 1:O_taille
    Ltr(i) = d*(i-1);
    f = polyval(coeff_d, xi);
    g = sqrt(1 + f.^2);
    xi = xi + d/g;
    O = [O, xi];
end

O = [O; polyval(coeff, O); polyval(coeff_d, O)];

end