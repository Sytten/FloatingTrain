Fs = 50.688 * 10^6;
dx = Fs/length(signal_1a);
x = 0:dx:Fs-dx;
figure
plot(x,abs(fft(signal_1a)))

LO2 = 10.7/2 * 10^6;
Osc = sin(2*pi*LO2*time);


signal_1a_osc = signal_1a .* Osc;
figure
plot(x,abs(fft(signal_1a_osc)))

n = -100:100;
filt = sinc(1/2*n)/2; % yolo pi/2
h = filt .* hamming(length(n))';

y = filter(h,1,signal_1a_osc);

%% 
close all
clc

figure
plot(x,abs(fft(y)))

y2 = y(1:64:length(y));
figure
x64 = x(1:64:end);
x64 = x64 ./ 64;
plot(x64,abs(fft(y2)))

%% filter with cheby
Fs2 = 791920/2;
[b,a] = cheby2(10,60,[230000/Fs2, 312000/Fs2], 'Bandpass');
fz = freqz(b,a);

dxz = (length(x64)/2)/length(fz);
xz = x64(1:dxz:end/2);
figure 
hold on
plot(x64,abs(fft(y2)))
plot(xz,abs(fz).*max(abs(fft(y2))))

%% filter
close all
clc

yz = filter(b,a,y2);
yz = filtfilt(b,a,yz);
figure
plot(x64,abs(fft(yz)))

%% redressage 

n = 12
pts = []
for i = 1:n:length(yz)-n
   m = sqrt(mean(yz(i:i+n).^2));
   pts = [pts, m];
end

figure 
plot(pts,'o')
hold on
plot([0,length(pts)],[0.12,0.12])


threshold = [0.08];

%% reconstruct bits 
step = 12;
result = [];
for i = 1:step:length(yz)
    bit = [0];
    bit(1) = bitValue(yz(i:i+step-1),threshold(1));
    result = [result; bit];
end

result = [result, baud_1a];
csvwrite('res.csv', result);

    