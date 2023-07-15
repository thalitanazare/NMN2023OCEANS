clear all
clc
close all

%System to be identified
y1(1)=0.5;

for k=2:10000;   
   y1(k)=1.2*pi*sin(y1(k-1));    
end

%Generating an arbitrary structure
model=genterms(5,3,0,0)

%modelo
[m,x]=orthreg(model,[],y1(1:500)',[10 0],10)

%Structure and parameters identified
tetas=x(:,1);
model=m;

%Simulation of the systems
ysim=simodeld(model,tetas,ones(1000,1),y1(501:503)');

%Comparison
figure(1);
plot(y1(1:end-1),y1(2:end),'.');
hold on
plot(ysim(1:end-1),ysim(2:end),'o');
hold off
xlabel('y(k)')
xlabel('y(k-1)')
legend('System','Model')


