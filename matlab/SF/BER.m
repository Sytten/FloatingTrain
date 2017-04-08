function [ pourcentage ] = BER( x, y )

ratio = 0;
for i = 1:length(x)
    if x(i) ~= y(i)
        ratio = ratio + 1;
    end   
end

pourcentage = ratio/length(x)*100;

end

