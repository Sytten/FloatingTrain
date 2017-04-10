function [ b ] = bitValue(x, t1 )
    if x >= t1
        b = 1;
    else
        b = 0;
    end
end