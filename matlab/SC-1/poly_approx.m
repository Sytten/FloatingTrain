function [ poly, RMS, COR ] = poly_approx( z, y, order )
%POLY_APPROX Summary of this function goes here
%   Detailed explanation goes here
N = length(y);
A = ones(N, 1);
for i = 1:order
    A = [A z.^i];
end

poly = pinv(A)*y;
[RMS, COR] = poly_rms_cor(z, y, fliplr(poly'));

end

