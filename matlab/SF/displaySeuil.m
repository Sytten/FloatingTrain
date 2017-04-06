function [ seuil ] = displaySeuil(yz)
n = 12;
pts = [];
for i = 1:n:length(yz)
   m = sqrt(mean((yz(i:i+n-1).*triang(n)).^2));
   pts = [pts, m];
end

lgt = 1:length(pts);

f = fit(lgt',pts','b*x^m');
seuil = f.b;


figure 
plot(pts,'o')
hold on
plot([0,length(pts)],[seuil, seuil])
end

