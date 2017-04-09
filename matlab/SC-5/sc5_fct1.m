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
    B = pi/(4*i);
    
    pxi = [ ones(1,length(x))',...
            sin(A*x),...
            cos(B*x)
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

x = [-0.02:0.0001:0.04];

y_test= coeffs(3)*cos(params(2)*x)+coeffs(2)*sin(params(1)*x)+coeffs(1);

figure 
plot(distance,voltage,'o')
hold on
plot(x, y_test)
axis([-0.02 0.04 -0.5 2.5])
title('Comparaison modèle sinusoïdale - Overfitting')
ylabel('Voltage (V)')
xlabel('Distance (m)')
figure
plot(distance,voltage,'+','LineWidth',1)
hold on
plot(distance, y_min_rms,'-r','LineWidth',2)
title('Comparaison modèle sinusoïdale')
ylabel('Voltage (V)')
xlabel('Distance (m)')
