clc
close all
clear all

%% Load constants

run('constants.m')
z = 0:0.001:0.2;
i = -1;

%%
Fsk = -1./(as0 + as1.*z + as2.*z.^2 +as3.*z.^3);



 Fek = ((i^2+be1*abs(i))*sign(i))./(ae0+ae1.*z + ae2.*z.^2+ae3.*z.^3);
f = (i.^3+be1*i)./(((ae0+ae1.*z + ae2.*z.^2+ae3.*z.^3)));
l = (be1+1)./(ae0+ae1.*z + ae2.*z.^2+ae3.*z.^3)+((2./(ae0+ae1.*z + ae2.*z.^2+ae3.*z.^3))*(i+1));


figure
hold on
%plot(i,f,'--r')
plot(z,Fek+Fsk)
%plot(i, l)
hold off

% % figure
% hold on
% for z = 0.0001:0.0001:0.01
% Fek = (i.^2+be1).*i./(abs(i).*(a0+a1*z + a2*z^2+a3*z^3));
% f = (i.^3+be1)./(be1*((a0+a1*z* + a2*z^2+a3*z^3)));
% err = (abs(f-Fek)./Fek) 
%     plot(i,err)
% 
% end
% hold off

syms f(x) df(x) x g(x)  dg(x) L(X) L1(X) L2(x) L3(X) X


f(x) = (i^2+be1*abs(i))*sign(i)./(ae0+ae1*x + ae2*x.^2+ae3*x.^3)
g(x) = (-1/(as0+as1*x+as2*x^2+as3*x^3))

% df(x) = (x^3*(be1+2*x))/((a0+a1*z + a2*z^2+a3*z^3)*abs(x)^3)
df(x) = ((i^2+be1*abs(i))*sign(i)*(ae1+x*(2*ae2+3*ae3*x)))./-(ae0+x*(ae1+x*(ae2+ae3*x)))^2
dg(x) = ((-(as1+x*(2*as2+3*as3*x)))/-(as0+x*(as1+x*(as2+as3*x)))^2)
%entrer le X ou l'on veut approximer
xx = 0.01;
L(X) = f(xx)+df(xx)*(X-xx) + (g(xx) + dg(xx)*(X-xx))
xx = 0.02;
L1(X) = f(xx)+df(xx)*(X-xx) + (g(xx) + dg(xx)*(X-xx))
xx = 0.03;
L2(X) = f(xx)+df(xx)*(X-xx) + (g(xx) + dg(xx)*(X-xx))
xx = 0.05;
L3(X) = f(xx)+df(xx)*(X-xx) + (g(xx) + dg(xx)*(X-xx))
X = 0:0.0005:0.2;
x = 0:0.0005:0.2;

% figure(666)
% 
% 
% hold on
% plot(X, L(X))
% plot(X,f(x)+g(x))
% hold off


Fk = Fek + Fsk;
Fkapprox = double(L(X)) ;
Fkapprox1 = double(L1(X)) ;
Fkapprox2 = double(L2(X)) ;
Fkapprox3 = double(L3(X)) ;

figure(777)
hold on
plot(z, Fk)
plot(X, Fkapprox)
plot(X, Fkapprox1)
plot(X, Fkapprox2)
plot(X, Fkapprox3)
%plot(z, (Fk - double(Fkapprox))./Fk, '--b')
legend('Fk originale','Approximation','Erreur absolue', 'Location','southeast')
title('Force des actionneurs en fonction de la distance avec la plaque et approximation linéaire')
axis([0 0.2 -10 10])
legend('0.01','0.02','0.03','0.05')
hold off

