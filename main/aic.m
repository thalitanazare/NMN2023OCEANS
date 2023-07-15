function f=aic(n,r,factor);

%function f=aic(n,r,factor);
%computes AIC=N.ln(sigma)^2 + factor.n
%n is the number of parameters in the model
%r is a column vector with the residuals
%factor is a constant. factor=2 for Akaike's inf criterion

%Luis A. Aguirre - Sheffield 15/7/92

N=length(r);
sigma2=(r'*r)/N;
f=N*log(sigma2) + factor*n;

