function [ b ] = bitValue(x, t1 )
    m = sqrt(mean((x.*triang(12)).^2));
    if m >= t1
        b = 1;
    else
        b = 0;
    end
end