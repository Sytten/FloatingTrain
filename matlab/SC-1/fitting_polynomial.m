clear all
close all
clc

load mesures_forces/Fs.mat
load mesures_forces/Fe_attraction.mat


N = length(Fs);
Fs_prime = -1 ./ Fs;
A = [ones(N, 1) z_pos z_pos.^2 z_pos.^3];

Y = pinv(A)*Fs

plot(z_pos,Fs, 'o')
hold on
y = polyval(fliplr(Y'),z_pos);
plot(z_pos, y)

%%
    
    format compact
    % disp(['order ', num2str(i)])
    % disp(Y)
  
    RMS = sqrt(1/N*sum((polyval(fliplr(Y'),Ouverture) - Coeff).^2));
    
    G = polyval(fliplr(Y'),Ouverture);
    Coeff_BAR = 1/N*sum(Coeff);
    COR = sum((G-Coeff_BAR).^2)/sum((Coeff-Coeff_BAR).^2);
    
    if i == 4
        distance = abs(y - 0.63);
        [~, idx] = min(distance);
        opening = x(idx)
        pY = [Y(5) Y(4) Y(3) Y(2) Y(1)-0.63];
        r = roots(pY);
    end
    
    figure
    hold on
    title(['Order:' num2str(i)])
    plot(Ouverture, Coeff, '*')
    plot(x, y)
    legend(['RMS:' num2str(RMS)],['COR:' num2str(COR)])
    xlabel('Ouverture de la valve (%)')
    ylabel('Coefficient de friction')