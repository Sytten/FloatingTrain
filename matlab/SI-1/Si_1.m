
% Est-ce que la sphère est présente 
%Filtré image (Contraste, couleur conserver surface blanche)
%Détection de la bille
%Si oui
%On trouve les axes 
%Trouver position de la bille
%%
clc
clear all
close all
%Chargé les images
Image = imread('image_552.bmp');
Bille = imread('Bille_zmin.bmp');
tic
%Image = Grayscale(Image)
posX = 138;
posY = 142;

%Image = Image(:,:,1);%(Image(:,:,1)/3+Image(:,:,2)/3+Image(:,:,3)/3);
Image = Image(posX-100:posX+100,posY-100:posX+100,1);%(Image(:,:,1)/3+Image(:,:,2)/3+Image(:,:,3)/3);
Bille = Bille(:,:,1);%(Bille(:,:,1)/3+Bille(:,:,2)/3+Bille(:,:,3)/3);
%Correlation 2D Normalise
%c = normxcorr2(Bille,Image);
c = normxcorr2_mex(double(Bille), double(Image));
toc
figure, surf(c), shading flat %Afficher le resultat de la correlation

%Trouver la position de la bille
[ypeak, xpeak] = find(c==max(c(:)));
yoffSet = ypeak-size(Bille,1); 
xoffSet = xpeak-size(Bille,2);

%Afficher resultat
hFig = figure;
hAx  = axes;
imshow(Image,'Parent', hAx);
imrect(hAx, [xoffSet+1, yoffSet+1, size(Bille,2), size(Bille,1)]);


 
 