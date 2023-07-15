function [x, modelo] = mqer(modelo,u,y,X0,A,B);

%
%               IMPOSIÇÃO DE RESTRIÇÕES AOS PARÂMETROS ESTIMADOS 
%                     POR MÍNIMOS QUADRADOS ESTENDIDOS - MQE
%
% [x, modelo] = MQER(modelo,u,y,tetas,A,B);
%
% Onde:
%
%         modelo => é o conjunto de termos candidatos considerados
%              u => sinal de entrada do sistema
%              y => sinal de saída do sistema
%             X0 => valor inicial para os parâmetros
%              A => coeficiente das restrições
%              B => valor das restrições
%
%              x => valor estimado por MQER
%         modelo => termos considerados de processo 
%           
%  
%Márcio Barroso
%PPGEE - CPDEE - UFMG
%GRUPO MACSIN
%Belo Horizonte, 17 de abril de 2001
%

%Inicialização
%------------------------------------------------
clc;
%------------------------------------------------

%Constrói a matriz de regressores
%------------------------------------------------
P = build_pr(modelo,u,y);
%------------------------------------------------

%Coloca o problema na forma de Lagrange
%------------------------------------------------
x_corr = inv(P'*P)*A'*inv(A*inv(P'*P)*A')*(A*X0-B);
%------------------------------------------------

%Resultado da correção
%------------------------------------------------
x = X0 - x_corr;
%------------------------------------------------

%-------------     FIM MQER    ------------------


