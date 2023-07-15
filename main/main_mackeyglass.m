    
clear all
clc
close all
format long
%System to be identified
% Mackey-Glass com e sem kahan
% Lembrar de substituir os dados lá na pasta análise

y1=[0.01;0.01;0.01;0.01;0.01;0.01;0.01;0.01;0.01;0.01];
N=1000;
for k=11:N
y1(k)=0.24662*10*y1(k-1) - 0.16423*10*y1(k-2) + 0.60992*y1(k-3) + 0.73012e-1*y1(k-5)^2*y1(k-10)^2 + 0.38566*y1(k-3)*y1(k-10) + 0.66999*y1(k-1)*y1(k-10)^2+ 0.88364*y1(k-1)^3- 0.67300*y1(k-4)*y1(k-10)^2- 0.11929*10*y1(k-1)^2 - 0.50451e-1*y1(k-4)*y1(k-5) - 0.24765*y1(k-1)^4 + 0.42081*y1(k-4)*y1(k-9)*y1(k-10)^2- 0.70406*y1(k-1)*y1(k-10)^3- 0.14089*y1(k-5)*y1(k-8)^2+ 0.14807*y1(k-1)*y1(k-7)*y1(k-10);
end
y1=y1';


%Generating an arbitrary structure
model=genterms(10,15,0,0);

%modelo
[m,x]=orthreg(model,[],y1(10:1000)',[25 0])

%Structure and parameters identified
tetas=x(:,1);
model=m;

%Simulation of the systems
ysim=simodeld(model,tetas,zeros(1000,1),y1(1:15)');

%Comparison
figure(1);
plot(y1,'k');
hold on
plot(ysim);
hold off
legend('System','Model')


