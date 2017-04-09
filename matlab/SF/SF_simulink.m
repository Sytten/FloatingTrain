close all
clear all
clc

load('signaux.mat')

signal = signal_1a;
baud = baud_1a;

% Oscillateur local L02
LO2 = 10.7 * 10^6 - Fs/128/2;
Osc = sin(2*pi*LO2*time)*2;

% Filtre rejet d'image
n = -10:9;
filt = sinc(1/64*n)/64;
h1 = filt .* hamming(length(n))';

% Bande de filtres
[b1,a1] = filtreCheby(-82500,Fs,4000000);
[b2,a2] = filtreCheby(82500,Fs,4000000);