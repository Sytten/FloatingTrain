clc
clear all
close all
    
ImageTest =(imread('image_552.bmp')); %%image_552 dans statique zmin version 2 /bmp
ImageBille = (imread('Bille_zmin.bmp'));
MeanBille = (ImageBille(:,:,1)./3 + ImageBille(:,:,2)./3 + ImageBille(:,:,3)./3); 
MeanImage = (ImageTest(:,:,1)./3 + ImageTest(:,:,2)./3 + ImageTest(:,:,3)./3); 
%imshow(MeanBille)
%edge(MeanImage)

%Corrélation entre Bille et Image Teste
L = length(MeanBille) + length(MeanImage)- 1;
H = size(MeanBille,1) + size(MeanImage,1)-1;

BB = padarray(MeanBille,[H-size(MeanBille,1) L-length(MeanBille)],0,'pre');
II = padarray(MeanImage,[H-size(MeanImage,1) L-length(MeanImage)],0,'pre');
Bfft = fft(BB,L);
Ifft = fft(II,L);
xcf = fftshift((ifft(Ifft .* conj(Bfft),L)));
plot(xcf);
[max idx] = max(xcf(:));
[x y] = ind2sub(size(xcf),idx)
TestImage = imread('image_552.bmp');
imshow(TestImage)
hold on;
plot(x,y,'r.','MarkerSize',20)

% cc = xcorr2(MeanImage,MeanBille);
% [max idx] = max(cc(:));
% [x y] = ind2sub(size(cc),idx)
% figure(2)
% imshow(TestImage)
% hold on;
% plot(x,y,'r.','MarkerSize',20)

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