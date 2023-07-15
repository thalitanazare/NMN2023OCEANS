function [x, modelo] = mqer(modelo,u,y,X0,A,B);

%
%               IMPOSI��O DE RESTRI��ES AOS PAR�METROS ESTIMADOS 
%                     POR M�NIMOS QUADRADOS ESTENDIDOS - MQE
%
% [x, modelo] = MQER(modelo,u,y,tetas,A,B);
%
% Onde:
%
%         modelo => � o conjunto de termos candidatos considerados
%              u => sinal de entrada do sistema
%              y => sinal de sa�da do sistema
%             X0 => valor inicial para os par�metros
%              A => coeficiente das restri��es
%              B => valor das restri��es
%
%              x => valor estimado por MQER
%         modelo => termos considerados de processo 
%           
%  
%M�rcio Barroso
%PPGEE - CPDEE - UFMG
%GRUPO MACSIN
%Belo Horizonte, 17 de abril de 2001
%

%Inicializa��o
%------------------------------------------------
clc;
%------------------------------------------------

%Constr�i a matriz de regressores
%------------------------------------------------
P = build_pr(modelo,u,y);
%------------------------------------------------

%Coloca o problema na forma de Lagrange
%------------------------------------------------
x_corr = inv(P'*P)*A'*inv(A*inv(P'*P)*A')*(A*X0-B);
%------------------------------------------------

%Resultado da corre��o
%------------------------------------------------
x = X0 - x_corr;
%------------------------------------------------

%-------------     FIM MQER    ------------------


