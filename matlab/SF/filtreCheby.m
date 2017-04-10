function [ b , a ] = filtreCheby( freq, Fs, m )
    f2 = freq + Fs/128/2;
    f3 = f2 * 64;
    fa = f3 - m;
    fb = f3 + m;
    [b,a] = cheby2(10,60,[fa/(Fs/2), fb/(Fs/2)], 'Bandpass');
end

