clear all
close all
clc

load('capteur.mat');

x = distance;
y = voltage;

starti = 1;
endi = 100;

y_min_rms = [];
min_rms = 1000;
min_rms_index = starti;
params = [0 0];
coeffs = [];
for i = starti:1:endi
    A = 1*i;
    B = 4*i;
    
    pxi = [ ones(1,length(x))',...
            log(A*(x+1)),...
            sin(B*(x+1))
            ];
    
    R = pinv(pxi)*y;
    
    G = 0;
    for j = 1:size(pxi,2)
        G = G + R(j)*pxi(:,j);
    end

    % calculate rms
    current_rms =  rms(voltage-G);
    
    % set smallest rms curve
    if (current_rms < min_rms)
        y_min_rms = G;
        min_rms = current_rms;
        min_rms_index = i;
        params = [A B];
        coeffs = R;
    end
    
    % display error
%     disp(['i = ', num2str(i), ' rms = ', num2str(current_rms)])
end
disp(['minimal rms = ', num2str(min_rms), ' at i = ', num2str(min_rms_index)])


figure 
plot(distance,y_min_rms)
hold on
plot(distance,voltage)