% %% Using imfindcircles
% clc
% clear all
% close all
%     
% A = imread('image_552.bmp');
% A = A(:,:,2);
% imshow(A)
% 
% Rmin = 10;
% Rmax = 20;
% tic
% [centersDark, radiiDark] = imfindcircles(A,[Rmin Rmax],'ObjectPolarity','dark');
% toc
% viscircles(centersDark, radiiDark,'LineStyle','--');

%% Using fft to genreate correlation
clc
clear all
close all
    
ImageTest = imcomplement(imread('image_552.bmp')); %%image_552 dans statique zmin version 2 /bmp
ImageBille = imcomplement(imread('Bille_zmin.bmp'));
MeanBille = (ImageBille(:,:,1)./3 + ImageBille(:,:,2)./3 + ImageBille(:,:,3)./3); 
MeanImage = (ImageTest(:,:,1)./3 + ImageTest(:,:,2)./3 + ImageTest(:,:,3)./3); 
%imshow(MeanBille)
%edge(MeanImage)

%Corrélation entre Bille et Image Teste
L = length(MeanBille) + length(MeanImage)- 1;
H = size(MeanBille,1) + size(MeanImage,1)-1;

BB = padarray(MeanBille,[H-size(MeanBille,1) L-length(MeanBille)],0,'post');
II = padarray(MeanImage,[H-size(MeanImage,1) L-length(MeanImage)],0,'post');
Bfft = fft(BB,L);
Ifft = fft(II,L);
xcf = fftshift((ifft(Ifft .* conj(Bfft),L)));
figure(1)
plot(xcf);
% 
% [max idx] = max(xcf(:));
% [x y] = ind2sub(size(xcf),idx)
% 
% TestImage = imread('image_552.bmp');
% imshow(TestImage)
% hold on;
% plot(x,y,'b.','MarkerSize',20)

%% Using xcorr2 to generate correlation
% cc = xcorr2(MeanImage,MeanBille);
% [max idx] = max(cc(:));
% [x y] = ind2sub(size(cc),idx)
% figure(2)
% imshow(TestImage)
% hold on;
% plot(x,y,'r.','MarkerSize',20)

