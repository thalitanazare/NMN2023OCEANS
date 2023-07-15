function u=urandn(n,m,um,vm)
%Input
% n - n�mero de amostras
% m - n�mero de amostrar para segurar
% um - media do sinal
% vm - variancia do sinal
%Output
% u - sa�da (vetor n*m x 1)

aux=randn(n,1);

if m>1
    for k=1:n
        maux(1:m,k)=aux(k);
    end
    u=reshape(maux,m*n,1);
else
    u=aux;
end


u=u/std(u)*vm^0.5;
u=u-mean(u)+um;