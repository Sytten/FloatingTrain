
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
% Charger les images
Image(:,:,:,1) = imread('image_718.bmp');
Image(:,:,:,2) = imread('image_751.bmp');
Image(:,:,:,3) = imread('image_785.bmp');
Image(:,:,:,4) = imread('image_818.bmp');
Image(:,:,:,5) = imread('image_852.bmp');
Image(:,:,:,6) = imread('image_884.bmp');
Image(:,:,:,7) = imread('image_918.bmp');
Image(:,:,:,8) = imread('image_951.bmp');
Image(:,:,:,9) = imread('image_985.bmp');
Image(:,:,:,10) = imread('image_1018.bmp');
N = 10;
Bille = imread('Bille_zmin.bmp');

%posX = 138;
%posY = 142;
%Image = im2double(Image(posX-100:posX+100,posY-100:posX+100,1, :));

Image = im2double(Image(:,:,1,:));
Bille = im2double(Bille(:,:,1));%(Bille(:,:,1)/3+Bille(:,:,2)/3+Bille(:,:,3)/3);

%% FFT correlation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A ne recalculer que quand la taille de Image change

% Matrix dimensions
adim = size(Image(:,:,1,1));
bdim = size(Bille);

% Cross-correlation dimension
cdim = adim+bdim-1;
bpad = zeros(cdim);
apad = zeros(cdim);

% Calcul de la FFT de la bille
BilleNorm = Bille - mean2(Bille);
bpad(1:bdim(1),1:bdim(2)) = BilleNorm(end:-1:1,end:-1:1);
fftb = fft2(bpad);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for n = 1:1:N
    
    % Calcul de la FFT de l'image
    tic
    apad(1:adim(1),1:adim(2)) = Image(:,:,1,n);
    ffta = fft2(apad);

    % Correlation
    correlation = real(ifft2(ffta.*fftb));
    toc

    % Affichage du résultat de la corrélation
    figure, surf(correlation), shading flat %Afficher le resultat de la correlation

    % Localisation de la bille
    [ypeak, xpeak] = find(correlation==max(correlation(:)));
    yoffSet = ypeak-size(Bille,1); 
    xoffSet = xpeak-size(Bille,2);

    % Dessin d'un rectangle sur la bille
    hFig = figure;
    hAx  = axes;
    imshow(Image(:,:,1,n),'Parent', hAx);
    hold on;
    plot(xoffSet+size(Bille,2)/2,yoffSet+size(Bille,2)/2,'b.','MarkerSize',20)
    %imrect(hAx, [xoffSet+1, yoffSet+1, size(Bille,2), size(Bille,1)]);

end




 