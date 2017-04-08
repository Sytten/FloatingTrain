% Auteur : Julien Larochelle, Philippe Girard
% Date de creation :  1 avril 2017
% Date d'edition : avril 2017
% Description du programme : RFID 1 émetteur

close all
clear all
clc

load('signaux.mat')

signal = signal_1b;
baud = baud_1b;

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

%% redressage 

test1 = displaySeuil(yz1,1);
test2 = displaySeuil(yz2,2);

%% reconstruct bits 
[ result1 ] = demodAM1(yz1,1, threshold(1));
[ result2 ] = demodAM1(yz2,2, threshold(2));

result = [test1+test1, baud];
delete('res.csv')
csvwrite('res.csv', result);

    