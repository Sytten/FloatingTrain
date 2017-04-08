function [result] = displaySeuil(yz, symbol)
n = 12;
pts = [];

for i = 1:n:length(yz)
   m = sqrt(mean((yz(i:i+n-1).*triang(n)).^2));
   pts = [pts, m];
end

moyenne = []

for j = 1:length(pts)
    
    moyenne1 = sum(pts(j:j+29))/30;
    moyenne = [moyenne, moyenne1];
     
end


figure 
hold on
plot(pts,'o')
plot(moyenne, '*')
hold off


result = [];
for i = 1:length(pts)
    bit = 0;
    bit = symbol*bitValue(pts(i),moyenne(i));
    result = [result; bit];
end


end

