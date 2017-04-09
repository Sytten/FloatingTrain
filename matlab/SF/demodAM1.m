function [ result ] = demodAM1( yz, symbol, threshold )
    pas = 12;
    result = [];
    for i = 1:pas:length(yz)
        bit = 0;
        bit = symbol*bitValue(yz(i:i+pas-1),threshold);
        result = [result; bit];
    end
end

