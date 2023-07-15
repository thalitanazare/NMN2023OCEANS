
clear all
clc
close all
format long
%System to be identified
load y_cc.csv;
load u_cc.csv;
y=y_cc(1:500:250000)';
y=y/abs(max(y));
u=u_cc(1:500:250000);
u=u/abs(max(u));

%-------------------------------------------------------------------------
% Generating an arbitrary structure ------------------------
lagy=2;
lagu=2;
model=[1001 0
2001 2001
1002 1002
2001 1001
1002 0
2001 1002
2001 0
2002 1001
2002 2001
2002 1002];

%Data traning
ut=u(1:250);
yt=y(1:250);
%Data Validation
uv=u(251+lagy:end);
yv=y(251+lagy:end);

%modelo
nterms=10;
[m,x]=orthreg(model,ut,yt',[nterms 0],0);

%Structure and parameters identified
tetas=x(:,1);
model=m;

%Simulation of the systems
ysim=simodeld(model,tetas,uv,y(251:250+lagy)');

%NRMSE
numc=(yv-ysim')*(yv-ysim')';
denc=(yv-mean(ysim'))*(yv-mean(ysim'))';
nrmse=sqrt(numc)/sqrt(denc)
%Comparison
figure(1);
plot(yv,'k');
hold on
plot(ysim,'r');
hold off
xlabel('k')
title('Comparacao Sistem x Modelo Geral para 10 Termos')
legend('System','Model')
% %-------------------------------------------------------------------------
% clear nterms
% err_total={};
% oper_total={};
% nrmse={};
% ysim1={};
% %-------------------------------------------------------------------------
% %entry
% for nterms=7:12  %changing number of terms
%     err_sum=[];
%     operations=[];
%     nrmse1=[];
%     ysim=[];
%     %choosing set of each nterms terms
%     a=1:15; %number of line for genterms(2,2,2)
%     b=nchoosek(a,nterms);
%     sizeB=size(b);
%     %Generating all the possibles arbitrary structure
% 
%     for k=1:sizeB(1)
%         model=[];
%         for i=1:nterms
%             p=terms(b(k,i),:);
%             model=[model;p;];
%         end
% 
%         %modelo
%         [m,x]=orthreg(model,u(200:500),y(200:500)',[nterms 0],0);
%         %ERR total for each model
%         %err_sum=[err_sum;sum(x(:,2));];
%         tetas=x(:,1);
%         [npr,nno,lag,ny,nu,ne,newmodel] = get_info(m);
%         noperations=(nterms-1)*64;
%                     for l=1:nterms
%                         if model(l,:)==0
%                             noperations=noperations;
%                         elseif model(l,1)==0 || model(l,2) ==0
%                             noperations=noperations+64^1.585;
%                         elseif model(l,:)~=0
%                             noperations=noperations+2*(64^1.585);
%                         end
%                     end
%         %------Delete values with NaN and Inf-----
%         if isnan(tetas)
% 
%         elseif isinf(tetas)
% 
%         else
%             ysim=simodeld(m,tetas,u(200:500),y(201:200+lag)');
%             if any(isnan(ysim))
% 
%             elseif any(isinf(ysim))
% 
%             else
%                 ysim1=[ysim1 ysim ];
%                 ysim=ysim';
%                 numc=(y(200:500)-ysim)*(y(200:500)-ysim)';
%                 denc=(y(200:500)-mean(ysim))*(y(200:500)-mean(ysim))';
%                 nrmse2=sqrt(numc)/sqrt(denc);
%                 if nrmse2<1
%                 nrmse1=[nrmse1; nrmse2;];
%                 %calculating number of operation in each model
%                 operations=[operations;noperations;];             
%                 end
%             end
%         end
%     end
%     nrmse=[nrmse nrmse1 ];
%     err_total=[err_total err_sum ]; %err total for all kind off models
%     oper_total=[oper_total operations ];%number operation total for all kind off models
% 
% end
% 
% %---------
% oper=[oper_total{1};oper_total{2};oper_total{3};oper_total{4};oper_total{5};oper_total{6}];
% nrmse_total=[nrmse{1};nrmse{2};nrmse{3};nrmse{4};nrmse{5};nrmse{6}];
% figure(2)
% plot(oper,nrmse_total,'o')
% xlabel('Number of Math Operations')
% ylabel('NRMSE')
% 
% %---------
% matriz_non=[oper nrmse_total];
% idxs = getNonDominated(matriz_non);
% figure(3)
% plot(oper(idxs),nrmse_total(idxs),'-o')
% xlabel('Number of math Operations')
% ylabel('NRMSE')
% %---------
% 
% 
% 
% % y_modelo=[ysim1{idxs(1)} ysim1{idxs(2)} ysim1{idxs(3)} ysim1{idxs(4)} ysim1{idxs(5)} ysim1{idxs(6)} ysim1{idxs(7)} ysim1{idxs(8)} ysim1{idxs(9)} ysim1{idxs(10)}];
% % 
% % figure(4);
% % subplot(6,3,1)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,1),'r');
% % hold off
% % xlabel('k')
% % title('14 Operações, NRMSE=',nrmse_total(idxs(1)))
% % 
% % 
% % subplot(6,3,2)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,2),'r');
% % hold off
% % xlabel('k')
% % title('15 Operações, NRMSE=',nrmse_total(idxs(2)))
% % 
% % 
% % subplot(6,3,3)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,3),'r');
% % hold off
% % xlabel('k')
% % title('16 Operações, NRMSE=',nrmse_total(idxs(3)))
% % 
% % subplot(6,3,4)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,4),'r');
% % hold off
% % xlabel('k')
% % title('17 Operações, NRMSE=',nrmse_total(idxs(4)))
% % 
% % subplot(6,3,5)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,5),'r');
% % hold off
% % xlabel('k')
% % title('18 Operações, NRMSE=',nrmse_total(idxs(5)))
% % 
% % subplot(6,3,6)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,6),'r');
% % hold off
% % xlabel('k')
% % title('19 Operações, NRMSE=',nrmse_total(idxs(6)))
% % 
% % subplot(6,3,7)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,7),'r');
% % hold off
% % xlabel('k')
% % title('20 Operações, NRMSE=',nrmse_total(idxs(7)))
% % 
% % subplot(6,3,8)
% % plot(y1,'k');
% % hold on
% % plot(y_modelo(:,8),'r');
% % hold off
% % xlabel('k')
% % title('22 Operações, NRMSE=',nrmse_total(idxs(8)))