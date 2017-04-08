% Auteur : Julien Larochelle, Philippe Girard
% Date de creation :  1 avril 2017
% Date d'edition : avril 2017
% Description du programme : RFID

close all
clear all
clc

load('signaux.mat')

% initial signal
Fs = 50.688 * 10^6;
dx = Fs/length(signal_1a);
x = 0:dx:Fs-dx;
% figure
% plot(x,abs(fft(signal_1a)))

% oscillateur local
LO2 = 10.7 * 10^6 - Fs/128/2;
Osc = sin(2*pi*LO2*time);

% déplacer le signal
signal_1a_osc = signal_1a .* Osc;
% figure
% plot(x,abs(fft(signal_1a_osc)))

% coupe bande à pi/64
n = -20:19;
filt = sinc(1/64*n)/64;
h1 = filt .* hamming(length(n))';
% figure
% l = 1;plot(0:l/length(n):l-l/length(n),abs(fft(h)));

% filtrer avec le coupe bande
y = filtfilt(h1,1,signal_1a_osc);
figure
plot(x,abs(fft(y)))

%% Sous-échantillonnage (64)
y64 = downsample(y,64);
figure 
x64 = x(1:64:end);
plot(x64,abs(fft(y64)))

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
threshold = 0.0125;
pts = displaySeuil(yz1,threshold);
displaySeuil(yz2,threshold);

%% reconstruct bits 
[ result1 ] = demodAM1(yz1,1, threshold);
[ result2 ] = demodAM1(yz2,2, threshold);

result = [result1+result2, baud_1a];
delete('res.csv')
csvwrite('res.csv', result);

    