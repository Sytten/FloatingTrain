clc
close all

SM_4
% FT plaque

%Entrée :Vphi 
%sortie : phi
[a_phi, b_phi] = ss2tf(A_phi,B_phi,C_phi,D_phi_1sortie,1);

FT_phi = tf(a_phi,b_phi)

figure 
rlocus(FT_phi)
title('FT \phi /V\phi')
VP_phi = eig(A_phi)
print('Lieu_phi_plaque','-dpng','-r300')

%Entrée :Vtheta
%sortie : theta
[a_theta, b_theta] = ss2tf(A_theta,B_theta,C_theta,D_theta_1sortie,1);

FT_theta = tf(a_theta,b_theta)
figure 
rlocus(FT_theta)
title('FT \theta /V\theta')
VP_theta = eig(A_theta)
print('Lieu_theta_plaque','-dpng','-r300')

%Entrée :Vz
%sortie : z
[a_z, b_z] = ss2tf(A_z,B_z,C_z,D_z_1sortie,1);

FT_z = tf(a_z,b_z)
figure 
rlocus(FT_z)
title('FT /Vz')
VP_z = eig(A_z)
print('Lieu_z_plaque','-dpng','-r300')



