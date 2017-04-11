clear all
close all
clc

position_commande = csvread('trajectoireofficielle/aller_interpole.csv')';
position_mesure = csvread('trajectoireofficielle/trajectoire_aller_asservie.csv')';

dx = length(position_mesure)/length(position_commande);
position_down = position_mesure(1:dx:end,1:2);
%% Display
figure
hold on
plot(position_commande(:,1), position_commande(:,2))
plot(position_mesure(:,1), position_mesure(:,2), 'r')

%% Reduce vector
coeff = polyfit(position_mesure(:,1), position_mesure(:,2), 20);
position_down = [position_commande(:,1), polyval(coeff, position_commande(:,1))];
position_down = [position_down, polyval(polyder(coeff), position_down(:,1))];

%% Display down
figure
hold on
plot(position_commande(:,1), position_commande(:,2))
plot(position_down(:,1), position_down(:,2), 'r')

%% Performance
Distance = sqrt((position_commande(:,1)-position_down(:,1)).^2 + (position_commande(:,2)-position_down(:,2)).^2);
Performance = [];
for i = 1:length(Distance)
    Performance = [Performance; sqrt(trapz(Distance(1:i).^2))];
end
