% Auteur : Julien Larochelle, Philippe Girard
% Date de creation :  8 avril 2017
% Date d'edition : avril 2017
% Description du programme : RFID avec 2 émetteurs

close all
clear all
clc

load('signaux.mat')

signal = signal_2b;
baud = baud_2b;

%% Function to filter and downsample
[x64, y64, Fs] = passeBasDownsample(signal, time);

%% filter with cheby
[b1,a1] = filtreCheby(-3*41250,Fs,3500000);
[b2,a2] = filtreCheby(-41250,Fs,3500000);
[b3,a3] = filtreCheby(41250,Fs,3500000);
[b4,a4] = filtreCheby(3*41250,Fs,3500000);
h1 = freqz(b1,a1,length(x64)/2);
h2 = freqz(b2,a2,length(x64)/2);
h3 = freqz(b3,a3,length(x64)/2);
h4 = freqz(b4,a4,length(x64)/2);

figure 
hold on
plot(x64,abs(fft(y64)))
plot(x64(1:end/2),abs(h1).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h2).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h3).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h4).*max(abs(fft(y64))))

%% filter
yz1 = filtfilt(b1,a1,y64);
yz2 = filtfilt(b2,a2,y64);
yz3 = filtfilt(b3,a3,y64);
yz4 = filtfilt(b4,a4,y64);
figure 
hold on
plot(x64,abs(fft(yz1)))
plot(x64,abs(fft(yz2)))
plot(x64,abs(fft(yz3)))
plot(x64,abs(fft(yz4)))

%% redressage et reconstruction bits

result1 = displaySeuil(yz1,1);
result2 = displaySeuil(yz2,3);
result3 = displaySeuil(yz3,2);
result4 = displaySeuil(yz4,4);

result1 = result1+result3;
result2 = result2+result4;

%% Calcul du BER
erreur1 = BER(baud(:,1),result1)
erreur2 = BER(baud(:,2),result2)

%% Ecriture dans un csv
write = [result1,result2, baud];
delete('res.csv')
csvwrite('res.csv', write);

    