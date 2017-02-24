function [ RMS, COR ] = poly_rms_cor( z, y, poly )
%POLY_RMS_COR Summary of this function goes here
%   Detailed explanation goes here

N = length(y);
RMS = sqrt(1/N*sum((polyval(poly,z) - y).^2));
G = polyval(poly,z);
y_BAR = 1/N*sum(y);
COR = sum((G-y_BAR).^2)/sum((y-y_BAR).^2);

end

