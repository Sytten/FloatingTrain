% Auteur : Julien Larochelle, Philippe Girard
% Date de creation :  8 avril 2017
% Date d'edition : avril 2017
% Description du programme : RFID avec 3 �metteurs

close all
clear all
clc


load('signaux.mat')

signal = signal_3b_2;
baud = baud_3b_2;

%% Function to filter and downsample
[x64, y64, Fs] = passeBasDownsample(signal, time);

%% filter with cheby
[b1,a1] = filtreCheby(-4.5*27500,Fs,2500000);
[b2,a2] = filtreCheby(-2.7*27500,Fs,2500000);
[b3,a3] = filtreCheby(-27500,Fs,2500000);
[b4,a4] = filtreCheby(27500,Fs,2500000);
[b5,a5] = filtreCheby(2.7*27500,Fs,2500000);
[b6,a6] = filtreCheby(4.5*27500,Fs,2500000);

h1 = freqz(b1,a1,length(x64)/2);
h2 = freqz(b2,a2,length(x64)/2);
h3 = freqz(b3,a3,length(x64)/2);
h4 = freqz(b4,a4,length(x64)/2);
h5 = freqz(b5,a5,length(x64)/2);
h6 = freqz(b6,a6,length(x64)/2);

figure 
hold on
plot(x64,abs(fft(y64)))
plot(x64(1:end/2),abs(h1).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h2).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h3).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h4).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h5).*max(abs(fft(y64))))
plot(x64(1:end/2),abs(h6).*max(abs(fft(y64))))

%% filter

yz1 = filtfilt(b1,a1,y64);
yz2 = filtfilt(b2,a2,y64);
yz3 = filtfilt(b3,a3,y64);
yz4 = filtfilt(b4,a4,y64);
yz5 = filtfilt(b5,a5,y64);
yz6 = filtfilt(b6,a6,y64);

figure 
hold on
plot(x64,abs(fft(yz1)))
plot(x64,abs(fft(yz2)))
plot(x64,abs(fft(yz3)))
plot(x64,abs(fft(yz4)))
plot(x64,abs(fft(yz5)))
plot(x64,abs(fft(yz6)))

%% redressage et reconstruction bits

result1 = displaySeuil(yz1,1);
result2 = displaySeuil(yz2,3);
result3 = displaySeuil(yz3,5);
result4 = displaySeuil(yz4,2);
result5 = displaySeuil(yz5,4);
result6 = displaySeuil(yz6,6);

result1 = result1+result4;
result2 = result2+result5;
result3 = result3+result6;

%% Calcul du BSR

erreur1 = BER(baud(:,1),result1)
erreur2 = BER(baud(:,2),result2)
erreur3 = BER(baud(:,3),result3)

%% Ecriture dans un csv
write = [result1, result2, result3, baud];
delete('res.csv')
csvwrite('res.csv', write);

    