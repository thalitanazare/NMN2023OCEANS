function u=urand(n,m,um,vm)
%Input
% n - número de amostras
% m - número de amostrar para segurar
% um - media do sinal
% vm - variancia do sinal
%Output
% u - saída (vetor n*m x 1)

aux=randn(n,1);
ruido=randn(length(ysr),1);
ruido=ruido/std(ruido)*var^0.5;
ruido=ruido-mean(ruido)+um;

for k=1:n
   maux(1:m,k)=aux(k);
end

u=reshape(maux,m*n,1);