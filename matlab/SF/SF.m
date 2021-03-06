% Auteur : Julien Larochelle, Philippe Girard
% Date de creation :  1 avril 2017
% Date d'edition : avril 2017
% Description du programme : RFID 1 �metteur

close all
clear all
clc

load('signaux.mat')

signal = signal_1b;
baud = baud_1b;

%% Function to filter and downsample
[x64, y64, Fs] = passeBasDownsample(signal, time);

%% filter with cheby
[b1,a1] = filtreCheby(-82500,Fs,4000000);
[b2,a2] = filtreCheby(82500,Fs,4000000);

h1 = freqz(b1,a1,length(x64)/2);
h2 = freqz(b2,a2,length(x64)/2);

figure 
hold on
plot(x64,abs(fft(y64)))
plot(x64(1:end/2),abs(h1).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h2).*max(abs(fft(y64))))

%% filter
yz1 = filtfilt(b1,a1,y64);
yz2 = filtfilt(b2,a2,y64);
figure 
hold on
plot(x64,abs(fft(yz1)))
plot(x64,abs(fft(yz2)))

%% redressage et reconstruction bits

result1 = displaySeuil(yz1,1);
result2 = displaySeuil(yz2,2);

result = result1+result2;

%% calcul du BER
erreur = BER(baud,result)

%% Ecriture dans un fichier csv
write = [result, baud];
delete('res.csv')
csvwrite('res.csv', write);



    