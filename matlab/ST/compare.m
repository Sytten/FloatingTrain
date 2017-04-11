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
plot(position_mesure(:,1), position_mesure(:,2))

%% Reduce vector
% position_down = [];
% for i = 1:length(position_commande)
%     x = position_commande(i,1);
%     idx = find(position_mesure > x,1);
%     position_down = [position_down; position_mesure(idx,:)];
% end

%% Display down
figure
hold on
plot(position_commande(:,1), position_commande(:,2))
plot(position_down(:,1), position_down(:,2))

%% Performance
Distance = sqrt((position_commande(:,1)-position_down(:,1)).^2 + (position_commande(:,2)-position_down(:,2)).^2);
Performance = sqrt(trapz(Distance.^2));
