
% Est-ce que la sph�re est pr�sente 
%Filtr� image (Contraste, couleur conserver surface blanche)
%D�tection de la bille
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

%Vecteur pour sauvegarder jusqua 6 position de la bille
BillePositions = [];
IndexBillesPosition = 1;

% Images � analyser
Plaque = im2double(Plaque(:,:,1,:));
Bille = im2double(Bille(:,:,1));

% Image normalis�e de la bille
BilleNorm = Bille - mean2(Bille);

% 1 si la bille a �t� d�tect�, 0 si elle ne l'as pas �t�
isBillePresente = 0;

% Demi taille du carr� d'analyse sur l'image de la plaque
demiTailleCarre = 100;


%% FFT correlation


for n = 1:1:N
    tic
    % Si la bille �tait pr�sente sur l'ancienne image on fait la
    % corr�lation sur une petite partie de l'image
    if isBillePresente == 1
        
        % V�rification que la partie de l'image qu'on veux analyser n'est
        % pas en dehors des limites de l'image
        zoneGauche = xPosBille-demiTailleCarre;
        if zoneGauche < 1
           zoneGauche = 1; 
        end
        zoneDroite = xPosBille+demiTailleCarre;
        if zoneDroite > 480
            zoneDroite = 480;
        end
        zoneHaute = yPosBille-demiTailleCarre;
        if zoneHaute < 1
            zoneHaute = 1;
        end
        zoneBasse = yPosBille+demiTailleCarre;
        if zoneBasse > 480
            zoneBasse = 480;
        end
        
        % S�lection de la zone � analyser
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
     
    % Si la bille n'�tait pas pr�sente, la corr�lation est faite sur la
    % plaque au complet
    else
        
        % Le d�but de la zone � analyser est en haut � gauche (on analyse toute l'image)
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
    % O� notre zone d'analyse se situe dans la grande image
    xPosBille = xPosBille + zoneGauche - 1;
    yPosBille = yPosBille + zoneHaute - 1;
    
    toc
    
    % Affichage du r�sultat de la corr�lation
    % figure, surf(correlation), shading flat %Afficher le resultat de la correlation
    
    % Seuillage pour d�terminer si la bille est pr�sente ou non
    if correlation(ypeak, xpeak) > 20
       isBillePresente = 1;
    else
       isBillePresente = 0;
       xPosBille = -1;
       yPosBille = -1;
    end
    
    % Dessin d'un point sur la bille si elle est pr�sente
    hFig = figure;
    hAx  = axes;
    imshow(Plaque(:,:,1,n),'Parent', hAx);
    hold on;
    % Si la bille est pr�sente,on sauvegarde jusqua 7 position et on affiche sa position
    if isBillePresente       
        if(IndexBillesPosition < 7)
            BillePositions(IndexBillesPosition,:) = [xPosBille yPosBille ];
            IndexBillesPosition = IndexBillesPosition +1;
        else
            IndexBillesPosition = 7;
            BillePositionsSize = size(BillePositions);
            if(BillePositionsSize(1) < 7)
                BillePositions(IndexBillesPosition,:) = [xPosBille yPosBille ];
            else
                BillePositions(1,:) = BillePositions(2,:);
                BillePositions(2,:) = BillePositions(3,:);
                BillePositions(3,:) = BillePositions(4,:);
                BillePositions(4,:) = BillePositions(5,:);
                BillePositions(5,:) = BillePositions(6,:);
                BillePositions(6,:) = BillePositions(7,:);
                BillePositions(IndexBillesPosition,:) = [xPosBille yPosBille];
            end
        end
        [vitesseX,vitesseY] = CalculVitesse(BillePositions,6);
%If ordreMax is impossible return 0 0
        plot(xPosBille, yPosBille,'b.','MarkerSize',20)
        disp(['La bille est presente � x:', num2str(xPosBille), ' y:', num2str(yPosBille)]);
        disp(['La bille a une vitesse x:', num2str(vitesseX), ' y:', num2str(vitesseY)]);
    else
        disp('La bille n''est pas presente');
    end

end




 