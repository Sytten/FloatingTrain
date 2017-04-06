function [ Vx,Vy ] = CalculVitesse( BillePositions,ordreMax ) 
% Calcul Vitesse effectue une dérivation numérique pour obtenir la vitesse
% de l'objet détecter. L'ordre de la dérivation numérique est sélectionnable
% entre 1 et 6. H est fixe à 1/30 de sec car la fréquence déchantillonage
% est 30Hz

% Équation voir : https://en.wikipedia.org/wiki/Backward_differentiation_formula

    % Clamp ordre max
    if ordreMax < 1
        ordreMax = 1;
        disp(['L''ordre demandé n''est pas valide, ordre 1 utilisé.']);
    elseif ordreMax > 6
        ordreMax = 6;
        disp(['L''ordre demandé n''est pas valide, ordre 6 utilisé.']);
    end
    
    % Numerical Derivation
    LastIdx = size(BillePositions);
    LastIdx = LastIdx(1);
    
    % Decide Best possible order to execute
    if LastIdx > ordreMax 
        ordre = ordreMax;
    else 
        ordre = LastIdx -1;
    end    
    
    switch(ordre)
        case 1 % Ordre 1
            vitesseX = (BillePositions(LastIdx,1) - BillePositions(LastIdx-1,1));
            vitesseY = (BillePositions(LastIdx,2) - BillePositions(LastIdx-1,2));
        case 2 % Ordre 2
            vitesseX = (3*BillePositions(LastIdx,1) - 4*BillePositions(LastIdx-1,1) + BillePositions(LastIdx-2,1))/2;
            vitesseY = (3*BillePositions(LastIdx,2) - 4*BillePositions(LastIdx-1,2) + BillePositions(LastIdx-2,2))/2;
        case 3 % Ordre 3
            vitesseX = (11*BillePositions(LastIdx,1) - 18*BillePositions(LastIdx-1,1) + 9*BillePositions(LastIdx-2,1) - 2*BillePositions(LastIdx-1,1))/6;
            vitesseY = (11*BillePositions(LastIdx,2) - 18*BillePositions(LastIdx-1,2) + 9*BillePositions(LastIdx-2,2) - 2*BillePositions(LastIdx-1,1))/6;
        case 4 % Ordre 4
            vitesseX = (25*BillePositions(LastIdx,1) - 48*BillePositions(LastIdx-1,1) + 36*BillePositions(LastIdx-2,1) - 16*BillePositions(LastIdx-3,1) + 3*BillePositions(LastIdx-4,1))/12;
            vitesseY = (25*BillePositions(LastIdx,2) - 48*BillePositions(LastIdx-1,2) + 36*BillePositions(LastIdx-2,2) - 16*BillePositions(LastIdx-3,2) + 3*BillePositions(LastIdx-4,1))/12;            
        case 5 % Ordre 5            
            vitesseX = (137*BillePositions(LastIdx,1) - 300*BillePositions(LastIdx-1,1) + 300*BillePositions(LastIdx-2,1) - 200*BillePositions(LastIdx-3,1) + 75*BillePositions(LastIdx-4,1) - 12*BillePositions(LastIdx-5,1))/60;
            vitesseY = (137*BillePositions(LastIdx,2) - 300*BillePositions(LastIdx-1,2) + 300*BillePositions(LastIdx-2,2) - 200*BillePositions(LastIdx-3,2) + 75*BillePositions(LastIdx-4,2) - 12*BillePositions(LastIdx-5,1))/60;
        case 6 % Ordre 6            
            vitesseX = (147*BillePositions(LastIdx,1) - 360*BillePositions(LastIdx-1,1) + 450*BillePositions(LastIdx-2,1) - 400*BillePositions(LastIdx-3,1) + 225*BillePositions(LastIdx-4,1) - 72*BillePositions(LastIdx-5,1) + 10*BillePositions(LastIdx-6,1))/60;
            vitesseY = (147*BillePositions(LastIdx,2) - 360*BillePositions(LastIdx-1,2) + 450*BillePositions(LastIdx-2,2) - 400*BillePositions(LastIdx-3,2) + 225*BillePositions(LastIdx-4,2) - 72*BillePositions(LastIdx-5,2) + 10*BillePositions(LastIdx-6,1))/60;
        otherwise
            vitesseX = 0;
            vitesseY = 0;
            disp(['L''ordre n''est pas valide.']);
    end
    % Return speed in units per seconds (px/s or m/s or whatever unit was in the matrix)
    Vx = vitesseX * 30; 
    Vy = vitesseY * 30;
end

