    
clear all
clc
format long
%System to be identified
load ACQ7000.DAT;
y1=ACQ7000(1:10:2000,3);
%y1=table2array(y1);
y1=y1';
u=ACQ7000(1:10:2000,2);
%Generating an arbitrary structure
model=genterms(2,4,1,0)

%modelo
[m,x]=orthreg(model,u(1:200),y1(1:200)',[8 0],10)

%Structure and parameters identified
tetas=x(:,1);
model=m;

%Simulation of the systems
ysim=simodeld(model,tetas,u(1:200),y1(1:4)');

%Comparison
figure(1);
plot(y1,'k');
hold on
plot(ysim,'r');
hold off
xlabel('k')
legend('System','Model')


