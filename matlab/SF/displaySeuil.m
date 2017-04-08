function [ pts ] = displaySeuil(yz, threshold)
n = 12
pts = []
for i = 1:n:length(yz)
   m = sqrt(mean((yz(i:i+n-1).*hamming(n)).^2));
   pts = [pts, m];
end

figure 
plot(pts,'o')
hold on
plot([0,length(pts)],[threshold, threshold])
end

