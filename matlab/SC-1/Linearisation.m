clear all
close all
clc

load mesures_forces/Fs.mat
load mesures_forces/Fe_attraction.mat

figure(1)
hold on
plot(Fe_m1A, z_m1A)
plot(Fe_m2A, z_m2A)
plot(Fs, z_pos)
hold off

% use cftool