clear all
close all
clc

load mesures_forces/Fs.mat
load mesures_forces/Fe_attraction.mat

% Fs Approximation
N = 150;
Fs_sub = Fs(1:N);
z = z_pos(1:N);

Fs_prime = -1 ./ Fs_sub;
[Y, RMS, COR] = poly_approx(z, Fs_prime, 3);

disp('Fs : as0   as1   as2   as3')
disp(['Poly : ', num2str(Y')])
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

figure
hold on
plot(z,Fs_sub, 'o')
y = polyval(fliplr(Y'),z);
plot(z, -1 ./ y)
title('Fs')
hold off

% Fe Approximation 1A
N = 150;
b = 13.029359254409743;
i = -1;
C1 = sign(i)*(i^2 + b*abs(i));
Fe1_sub = Fe_m1A(1:N);
z1 = z_m1A(1:N);

Fe1_prime = C1 ./ Fe1_sub;
[Y1, RMS, COR] = poly_approx(z1, Fe1_prime, 3);

disp('Fe_m1A : ae0   ae1   ae2   ae3')
disp(['Poly : ', num2str(Y1')])
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

figure
hold on
plot(z1,Fe1_sub, 'o')
y = polyval(fliplr(Y1'),z1);
plot(z1, C1 ./ y)
title('Fe m1A')
hold off

% Fe Approximation 2A
N = 150;
b = 13.029359254409743;
i = -2;
C2 = sign(i)*(i^2 + b*abs(i));
Fe2_sub = Fe_m2A(1:N);
z2 = z_m2A(1:N);

Fe2_prime = C2 ./ Fe2_sub;
[Y2, RMS, COR] = poly_approx(z2, Fe2_prime, 3);

disp('Fe_m2A : ae0   ae1   ae2   ae3')
disp(['Poly : ', num2str(Y2')])
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

figure
hold on
plot(z2,Fe2_sub, 'o')
y = polyval(fliplr(Y2'),z2);
plot(z2, C2 ./ y)
title('Fe m2A')
hold off

% Average curves
Y = (Y1 + Y2)./2;
disp('Average Fe : ae0   ae1   ae2   ae3')
disp(['Poly : ', num2str(Y')])

[RMS, COR] = poly_rms_cor(z1, Fe1_prime, fliplr(Y'));
disp('Fe_m1A with average curve')
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

[RMS, COR] = poly_rms_cor(z2, Fe2_prime, fliplr(Y'));
disp('Fe_m2A with average curve')
disp(['RMS : ', num2str(RMS)])
disp(['COR : ', num2str(COR)])

figure
hold on
plot(z1,Fe1_sub, 'o')
y = polyval(fliplr(Y'),z1);
plot(z1, C1 ./ y)

plot(z2,Fe2_sub, 'o')
y = polyval(fliplr(Y'),z2);
plot(z2, C2 ./ y)
hold off