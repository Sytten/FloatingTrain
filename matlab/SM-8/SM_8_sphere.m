clc
close all

%Entr�e :theta
%sortie : X sph�re
[a_xs, b_xs] = ss2tf(AxS,BxS,CxS,DxS,1);

FT_xs = tf(a_xs(1,:),b_xs)
figure 
rlocus(FT_xs)
title('FT X sph�re')
VP_xs = eig(AxS)
print('Lieu_X_sphere','-dpng','-r300')

%Entr�e :theta
%sortie : omegaX sph�re

FT_omega_xs = tf(a_xs(2,:),b_xs)
figure 
rlocus(FT_omega_xs)
title('FT \omega_xs ')
print('Lieu_omegaX_sphere','-dpng','-r300')

%%

%Entr�e :phi 
%sortie : Y sph�re
[a_ys, b_ys] = ss2tf(AyS,ByS,CyS,DyS,1);

FT_ys = tf(a_ys(1,:),b_ys)
figure 
rlocus(FT_ys)
title('FT Y sph�re')
VP_ys = eig(AyS)
print('Lieu_Ys_sphere','-dpng','-r300')

%Entr�e :phi 
%sortie : Y sph�re

FT_omega_ys = tf(a_ys(2,:),b_ys)
figure 
rlocus(FT_omega_ys)
title('FT \omega_Y')
print('Lieu_omegaX_sphere','-dpng','-r300')




