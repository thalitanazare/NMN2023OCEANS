
% WEC model identification - NARMAX - Reduce Carbon footprint
% Thalita Nazare
% Dec 2022

clear all;clc;close all
format long

% System to be identified ----------------------------------
load wave_elevation.txt;
load body1_float_position.txt; 
load body1_float_forceexci.txt;
load output.txt;
load input.txt
y=output(1:110:end)';
y=y/abs(max(y));
u=input(1:110:end);
u=u/abs(max(u));

% Generating an arbitrary structure ------------------------
lagy=2;
lagu=2;
terms=genterms(2,lagy,lagu,0);

%Data traning
ut=u(1:300);
yt=y(1:300);
%Data Validation
uv=u(301+lagy:end-90);
yv=y(301+lagy:end-90);

err_total={};
oper_total={};
nrmse={};
ysim1={};

%-------------------------------------------------------------------------
%entry
for nterms=7:12 %changing number of terms
    err_sum=[];
    operations=[];
    nrmse1=[];
    ysim=[];
    %choosing set of each nterms terms
    a=1:15; %number of line for genterms(2,2,2)
    b=nchoosek(a,nterms);
    sizeB=size(b);
    %Generating all the possibles arbitrary structure

    for k=1:sizeB(1)
        model=[];
        for i=1:nterms
            p=terms(b(k,i),:);
            model=[model;p;];
        end

        %modelo
        [m,x]=orthreg(model,ut,yt',[nterms 0],0);
        %ERR total for each model
        %err_sum=[err_sum;sum(x(:,2));];
        tetas=x(:,1);
        [npr,nno,lag,ny,nu,ne,newmodel] = get_info(m);
        nbits=(nterms-1)*64;
                    for l=1:nterms
                        if model(l,:)==0
                            nbits=nbits;
                        elseif model(l,1)==0 || model(l,2) ==0
                            nbits=nbits+64^1.585;
                        elseif model(l,:)~=0
                            nbits=nbits+2*(64^1.585);
                        end
                    end
        %------Delete values with NaN and Inf-----
        if isnan(tetas)

        elseif isinf(tetas)

        else
            ysim=simodeld(m,tetas,uv,y(301:300+lagy)');
            if any(isnan(ysim))

            elseif any(isinf(ysim))

            else
                ysim1=[ysim1 ysim ];
                ysim=ysim';
                numc=(yv-ysim)*(yv-ysim)';
                denc=(yv-mean(ysim))*(yv-mean(ysim))';
                nrmse2=sqrt(numc)/sqrt(denc);
                if nrmse2<1
                nrmse1=[nrmse1; nrmse2;];
                %calculating number of bits in each model
                operations=[operations;nbits;];             
                end
            end
        end
    end
    nrmse=[nrmse nrmse1 ];
    err_total=[err_total err_sum ]; %err total for all kind off models
    oper_total=[oper_total operations ];%number operation total for all kind off models

end
%---------
oper=[oper_total{1};oper_total{2};oper_total{3};oper_total{4};oper_total{5};oper_total{6}];
oper=oper*6.0190e-4;
nrmse_total=[nrmse{1};nrmse{2};nrmse{3};nrmse{4};nrmse{5};nrmse{6}];
figure(2)
plot(oper,nrmse_total,'o')
xlabel('$\mu gCO_2e$','Interpreter','latex')
ylabel('NRMSE')

%---------
matriz_non=[oper nrmse_total];
idxs = getNonDominated(matriz_non);
figure(3)
plot(oper(idxs),nrmse_total(idxs),'-o')
xlabel('$\mu gCO_2e$','Interpreter','latex')
ylabel('NRMSE')
%---------

% k=1;
% for n=1:100
%     n
% tic    
% for k=1:1e8
%     k=3*6;
% end
% m(n)=toc
% end
% med=mean(m);
% mult=64^1.585;
% co2= 5.87;
% bco2=co2*med/mult/1e8 %(gCO2e) % gram CO2emission
% %bco2 =
% %
% %   2.3696e-12   => 0.000002396 mgCO2e (micro gramma)
% %Example
% %Complexity 10000 times 250 simulations 
% %Number for graph
% 10000*250*bco2
% %ans =
% 
% %   5.9241e-06 => 5.92 (\mu gCO2e)
% % Factor to muliplity the complexity
% 250*bco2
% %ans =
% %
% %   6.0190e-10