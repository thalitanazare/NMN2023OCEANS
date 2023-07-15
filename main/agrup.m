function [AGRUPS] = agrup(modelo,u,y,flag1,flag2)
%
%	A Função [AGRUPS] = AGRUP(modelo,u,y,flag1,flag2) mostra graficamente a
%evolução dos coeficientes dos agrupamentos de termos com o números de termos de
%processo utilizado.
%
% Onde:
%
%         modelo => é o código do modelo a ser avaliado
%              u => são os dados de entrada do sistema a ser modelado
%              y => são os dados de  saída  do sistema a ser modelado
%          flag1 => (1) para a visualização gráfica dos resultados
%                   (0) para o contrário
%
%          flag2 => se (1) para flag1, determina o número da figura a ser
%                   considerada
%
%         AGRUPS => evolução dos resultados
%
%
% Márcio Barroso
% PPGEE - CPDEE - UFMG
% GRUPO MACSIN
% Belo Horizonte, 25 de maio de 2001
%

%Verificar a dimensão do modelo (np x col)
%------------------------------------------------
[np col] = size(modelo);
%------------------------------------------------

%Valores iniciais para os coeficientes dos agrupamentos
%------------------------------------------------
[yconst2,yy2,yc2] = coefc(modelo,zeros(length(modelo),1));
%------------------------------------------------

%Define as dimensões dos agrupamentos (ln x cn)
%------------------------------------------------
[l1 c1] = size(yconst2);
[l2 c2] = size(yy2);
[l3 c3] = size(yc2);
%------------------------------------------------

%	Iterações para o cálculo dos coeficientes dos agrupamentos pelo número de
%termos
%------------------------------------------------
for k = 1 : np
  clc;
  disp(sprintf('Iteração (%i) de um total de (%i)',k,np))
  [modelo2,x]  = orthreg(modelo(1:k,:),u,y,np);
  [yconst,yy,yc] = coefc(modelo2,x(:,1));
         yconst2 = [yconst2 yconst];
             yy2 = [yy2 yy];   
             yc2 = [yc2 yc];
end
%------------------------------------------------

%Guarda os resultados em variáveis auxiliares
%------------------------------------------------
C(1,:) = yconst2(1,1:c1:end);
for k3 = 1 : l2
    B(k3,:) = yy2(k3,1:c2:end);
end
p = 0;
for k4 = 1 : c3
     for k5 = 1 : l3
         if  (k4 <= c3) & (k5 <= l3)
              p = p + 1;
         end 
     A(p,:) = yc2(k5,k4:c3:end);
     end
end
%------------------------------------------------

%Define a saída da função
%------------------------------------------------
AGRUPS = [C; B; A];
[z q] = size(AGRUPS);
w = sqrt(z);
%------------------------------------------------

%Mostra graficamente os reaultados
%------------------------------------------------
for kk = 1 : z
 figure(flag)
 subplot(w,w,kk);plot(AGRUPS(kk,:));title(sprintf('%i',kk));
end
%------------------------------------------------

%---------------------FIM------------------------