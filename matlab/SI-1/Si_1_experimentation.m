clc
clear all
close all
    
ImageTest = imcomplement(imread('image_552.bmp'));
ImageBille = imcomplement(imread('Bille_zmin.bmp'));

MeanBille = (ImageBille(:,:,1)./3 + ImageBille(:,:,2)./3 + ImageBille(:,:,3)./3); 
MeanImage = (ImageTest(:,:,1)./3 + ImageTest(:,:,2)./3 + ImageTest(:,:,3)./3); 

imshow(MeanBille)
%Corr�lation entre Bille et Image Teste

%edge(MeanImage)


%%
% lags = [-4, -3 -2, -1, 0, 1, 2, 3, 4];
% x = [1 1 2 -1 1];
% y = [-1 2 1 0.5 2];
% xc = xcorr(x, y);
% subplot(2, 1, 1);
% plot(lags, xc);
% grid
% 
% L = length(x) + length(y) - 1;
% xx = [x'; zeros(1, L - length(x))'];
% yy = [y'; zeros(1, L - length(y))'];
% xft = fft(xx, L);
% yft = fft(yy, L);
% xcf = real(ifft(xft .* conj(yft), L));
% xcf = circshift(xcf, (L-1)/2);
% subplot(2, 1, 2);
% plot(lags, xcf);
% grid