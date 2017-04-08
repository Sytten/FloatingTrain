function [ x64, y64, Fs ] = passeBasDownsample( signal, time )
    % initial signal
    Fs = 50.688 * 10^6;
    dx = Fs/length(signal);
    x = 0:dx:Fs-dx;
    % figure
    % plot(x,abs(fft(signal)))

    % oscillateur local
    LO2 = 10.7 * 10^6 - Fs/128/2;
    Osc = sin(2*pi*LO2*time);

    % déplacer le signal
    signal_osc = signal .* Osc;
    % figure
    % plot(x,abs(fft(signal_osc)))

    % coupe bande à pi/64
    n = -20:19;
    filt = sinc(1/64*n)/64;
    h1 = filt .* hamming(length(n))';
    % figure
    % l = 1;plot(0:l/length(n):l-l/length(n),abs(fft(h)));

    % filtrer avec le coupe bande
    y = filtfilt(h1,1,signal_osc);
    figure
    plot(x,abs(fft(y)))

    %% Sous-échantillonnage (64)
    y64 = downsample(y,64);
    figure 
    x64 = x(1:64:end);
    plot(x64,abs(fft(y64)))
end

