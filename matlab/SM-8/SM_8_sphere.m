clc
close all

%Entr�e :phi 
%sortie : X sph�re
[a_phi_x, b_phi_x] = ss2tf(AxS,BxS,CxS,DxS,1);

FT_phi_X = tf(a_phi_x(1,:),b_phi_x)
figure 
rlocus(FT_phi_X)
title('FT Xs / \phi')
VP_phi = eig(AxS)
print('Lieu_Xs_sphere','-dpng','-r300')

%Entr�e :phi 
%sortie : omegaX sph�re
[a_phi_x, b_phi_x] = ss2tf(AxS,BxS,CxS,DxS,1);

FT_phi_omega = tf(a_phi_x(2,:),b_phi_x)
figure 
rlocus(FT_phi_omega)
title('FT \omega_X / \phi')
VP_phi = eig(AxS)
print('Lieu_omegaX_sphere','-dpng','-r300')

%%

%Entr�e :phi 
%sortie : X sph�re
[a_phi_x, b_phi_x] = ss2tf(AxS,BxS,CxS,DxS,1);

FT_phi_X = tf(a_phi_x(1,:),b_phi_x)
figure 
rlocus(FT_phi_X)
title('FT Xs / \phi')
VP_phi = eig(AxS)
print('Lieu_Xs_sphere','-dpng','-r300')

%Entr�e :phi 
%sortie : omegaX sph�re
[a_phi_x, b_phi_x] = ss2tf(AxS,BxS,CxS,DxS,1);

FT_phi_omega = tf(a_phi_x(2,:),b_phi_x)
figure 
rlocus(FT_phi_omega)
title('FT \omega_X / \phi')
VP_phi = eig(AxS)
print('Lieu_omegaX_sphere','-dpng','-r300')




