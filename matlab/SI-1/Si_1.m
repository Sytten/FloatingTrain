
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
Plaque(:,:,:,1) = imread('image_718.bmp');
Plaque(:,:,:,2) = imread('image_751.bmp');
Plaque(:,:,:,3) = imread('image_785.bmp');
Plaque(:,:,:,4) = imread('image_818.bmp');
Plaque(:,:,:,5) = imread('image_852.bmp');
Plaque(:,:,:,6) = imread('image_884.bmp');
Plaque(:,:,:,7) = imread('image_918.bmp');
Plaque(:,:,:,8) = imread('image_951.bmp');
Plaque(:,:,:,9) = imread('image_985.bmp');
Plaque(:,:,:,10) = imread('image_1018.bmp');
N = 10;
Bille = imread('Bille_zmin.bmp');

% Images à analyser
Plaque = im2double(Plaque(:,:,1,:));
Bille = im2double(Bille(:,:,1));

% Image normalisée de la bille
BilleNorm = Bille - mean2(Bille);

% 1 si la bille a été détecté, 0 si elle ne l'as pas été
isBillePresente = 0;

% Demi taille du carré d'analyse sur l'image de la plaque
demiTailleCarre = 100;


%% FFT correlation


for n = 1:1:N
    tic
    % Si la bille était présente sur l'ancienne image on fait la
    % corrélation sur une petite partie de l'image
    if isBillePresente == 1
        
        % Vérification que la partie de l'image qu'on veux analyser n'est
        % pas en dehors des limites de l'image
        zoneGauche = xPosBille-demiTailleCarre;
        if zoneGauche < 1
           zoneGauche = 1; 
        end
        zoneDroite = xPosBille+100;
        if zoneDroite > 480
            zoneDroite = 480;
        end
        zoneHaute = yPosBille-100;
        if zoneHaute < 1
            zoneHaute = 1;
        end
        zoneBasse = yPosBille+100;
        if zoneBasse > 480
            zoneBasse = 480;
        end
        
        % Sélection de la zone à analyser
        PetitePlaque = Plaque(zoneHaute:zoneBasse,zoneGauche:zoneDroite,1,n);
        
        % Matrix dimensions
        adim = size(PetitePlaque);
        bdim = size(Bille);
        
        % Cross-correlation dimension
        cdim = adim+bdim-1;
        bpad = zeros(cdim);
        apad = zeros(cdim);

        % Calcul de la FFT de la bille
        bpad(1:bdim(1),1:bdim(2)) = BilleNorm(end:-1:1,end:-1:1);
        fftb = fft2(bpad);
        
        % Calcul de la FFT de l'image
        apad(1:adim(1),1:adim(2)) = PetitePlaque(:,:);
        ffta = fft2(apad);

        % Correlation
        correlation = real(ifft2(ffta.*fftb));
     
    % Si la bille n'était pas présente, la corrélation est faite sur la
    % plaque au complet
    else
        
        % Le début de la zone à analyser est en haut à gauche (on analyse toute l'image)
        zoneGauche = 1;
        zoneHaute = 1;
        
        % Matrix dimensions
        adim = size(Plaque(:,:,1,1));
        bdim = size(Bille);

        % Cross-correlation dimension
        cdim = adim+bdim-1;
        bpad = zeros(cdim);
        apad = zeros(cdim);

        % Calcul de la FFT de la bille
        bpad(1:bdim(1),1:bdim(2)) = BilleNorm(end:-1:1,end:-1:1);
        fftb = fft2(bpad);
        
        % Calcul de la FFT de l'image
        apad(1:adim(1),1:adim(2)) = Plaque(:,:,1,n);
        ffta = fft2(apad);

        % Correlation
        correlation = real(ifft2(ffta.*fftb));
        
    end
    
    % Localisation de la bille
    [ypeak, xpeak] = find(correlation==max(correlation(:)));
    yoffSet = ypeak-size(Bille,1); 
    xoffSet = xpeak-size(Bille,2);
    xPosBille = xoffSet+size(Bille,2)/2;
    yPosBille = yoffSet+size(Bille,2)/2;
    % Où notre zone d'analyse se situe dans la grande image
    xPosBille = xPosBille + zoneGauche - 1;
    yPosBille = yPosBille + zoneHaute - 1;
    
    toc
    
    % Affichage du résultat de la corrélation
    figure, surf(correlation), shading flat %Afficher le resultat de la correlation
    
    % Seuillage pour déterminer si la bille est présente ou non
    if correlation(ypeak, xpeak) > 20
       isBillePresente = 1;
    else
       isBillePresente = 0;
       xPosBille = -1;
       yPosBille = -1;
    end
    
    
    % Dessin d'un point sur la bille si elle est présente
    hFig = figure;
    hAx  = axes;
    imshow(Plaque(:,:,1,n),'Parent', hAx);
    hold on;
    
    % Si la bille est présente, on affiche sa position
    if isBillePresente
        plot(xPosBille, yPosBille,'b.','MarkerSize',20)
        disp(['La bille est presente à x:', num2str(xPosBille), ' y:', num2str(yPosBille)]);
    else
        disp('La bille n''est pas presente');
    end

end




 