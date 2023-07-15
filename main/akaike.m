function [f, mint] = akaike(modelo,u,y,flag,flag2);
%
% A Fun��o [f, mint] = AKAIKE(modelo,u,y,flag,flag2)
%
%   Mostra atrav�s do crit�rio de informa��o de Akaike o n�mero 
% aproximado de termos de processo a ser considerado na sele��o
% de estrutura.
%
%   Onde:
%
%         modelo => matriz c�digo dos termos candidatos;
%              u => dados de entrada do sistema a ser modelado;
%              y => dados de   sa�da do sistema a ser modelado;
%           flag => se  (1) mostra o resultado de forma gr�fica;
%                   se (~1) n�o mostra os resultados de forma gr�fica;
%          flag2 => retorna o n�mero da figura a ser considerada caso
%                   flag seja (1);
%
%              f => seq��ncia contendo os dados do crit�rio de Akaike;
%           mint => o n�mero de termos de processo a ser considerado.
%
%
%
%M�rcio Barroso
%PPGEE - CPDEE - UFMG
%GRUPO MACSIN
%Belo Horizonte, 10 de abril de 2001


%Define o tamanho do modelo
%------------------------------------------------
np = length(modelo);
%------------------------------------------------

%Itera��es para o c�lculo do crit�rio
%------------------------------------------------
for i =  1 : np
    clc
    disp(sprintf('Itera��o (%i) de um total de (%i)',i,np))
    [m,x,e] = orthreg(modelo,u,y,i);
    f(i) = aic(i,e,2);
end
%------------------------------------------------

%Mostra graficamente o resultado
%------------------------------------------------
if flag == 1
    figure(flag2)
    h = figure(flag2); 
    set(h,'name','Crit�rio de Informa��o AKAIKE','numbertitle','off');
    plot(f);title('Crit�rio de AKAIKE');xlabel('N�mero de Termos')
end
%------------------------------------------------

%Define o n�mero de termos de processo a ser considerado
%------------------------------------------------
mint = find(f == min(f));
%------------------------------------------------

%----------------------FIM-----------------------