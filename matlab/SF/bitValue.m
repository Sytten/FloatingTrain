function [ b ] = bitValue(x, threshold )
    m = sqrt(mean(x.^2));
    if m >= threshold
        b = 1;
    else
        b = 0;
    end
end