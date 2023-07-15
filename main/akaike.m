function [f, mint] = akaike(modelo,u,y,flag,flag2);
%
% A Função [f, mint] = AKAIKE(modelo,u,y,flag,flag2)
%
%   Mostra através do critério de informação de Akaike o número 
% aproximado de termos de processo a ser considerado na seleção
% de estrutura.
%
%   Onde:
%
%         modelo => matriz código dos termos candidatos;
%              u => dados de entrada do sistema a ser modelado;
%              y => dados de   saída do sistema a ser modelado;
%           flag => se  (1) mostra o resultado de forma gráfica;
%                   se (~1) não mostra os resultados de forma gráfica;
%          flag2 => retorna o número da figura a ser considerada caso
%                   flag seja (1);
%
%              f => seqüência contendo os dados do critério de Akaike;
%           mint => o número de termos de processo a ser considerado.
%
%
%
%Márcio Barroso
%PPGEE - CPDEE - UFMG
%GRUPO MACSIN
%Belo Horizonte, 10 de abril de 2001


%Define o tamanho do modelo
%------------------------------------------------
np = length(modelo);
%------------------------------------------------

%Iterações para o cálculo do critério
%------------------------------------------------
for i =  1 : np
    clc
    disp(sprintf('Iteração (%i) de um total de (%i)',i,np))
    [m,x,e] = orthreg(modelo,u,y,i);
    f(i) = aic(i,e,2);
end
%------------------------------------------------

%Mostra graficamente o resultado
%------------------------------------------------
if flag == 1
    figure(flag2)
    h = figure(flag2); 
    set(h,'name','Critério de Informação AKAIKE','numbertitle','off');
    plot(f);title('Critério de AKAIKE');xlabel('Número de Termos')
end
%------------------------------------------------

%Define o número de termos de processo a ser considerado
%------------------------------------------------
mint = find(f == min(f));
%------------------------------------------------

%----------------------FIM-----------------------