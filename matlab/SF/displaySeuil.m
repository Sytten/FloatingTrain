function [result] = displaySeuil(yz, symbol)
n = 12;
pts = [];
long = 45;

% Determination du nuage de points
for i = 1:n:length(yz)
   m = sqrt(mean((yz(i:i+n-1).*triang(n)).^2));
   pts = [pts, m];
end

% Moyenne mobile du seuil
moyenne = [];
for j = 1:length(pts)-long
    
    moyenne1 = sum(pts(j:j+long-1))/long;
    moyenne = [moyenne, moyenne1];
     
end
moyenne(810-long:810) = moyenne(810-long-1);


figure 
hold on
plot(pts,'o')
plot(moyenne, '*')
hold off

% Resultat du seuillage et retour du resultat
result = [];
for i = 1:length(pts)
    bit = 0;
    bit = symbol*bitValue(pts(i),moyenne(i));
    result = [result; bit];
end

end

