clear all
close all
clc

load('capteur.mat');

x = distance;
y = voltage;

err = []
initial = 1;
for i = initial:1:100

    A = 1*i;
    B = 2*i;
    
p1 = ones(size(x));
p2 = exp(A*x);
p3 = exp(B*2*x);

PM3 = [p1,p2,p3];

SM3 = pinv(PM3)*y;


x = distance;
ybM3 = SM3(3)*p3+ SM3(2)*p2 + SM3(1);
% figure 
% plot(distance,ybM3)
% hold on
% plot(distance,voltage)

cr =  rms(voltage-ybM3);
err = [err cr];
disp(['i = ', num2str(i), ' rms = ', num2str(cr)])
end

[me, mi] = min(err);
disp(['minimal rms = ', num2str(me), ' at i = ', num2str(mi+initial-1)])