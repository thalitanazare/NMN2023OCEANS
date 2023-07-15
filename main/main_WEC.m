
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
model=genterms(2,lagy,lagu,0);

%Data traning
ut=u(1:300);
yt=y(1:300);
%Data Validation
uv=u(301+lagy:end-90);
yv=y(301+lagy:end-90);

%akaike
%[f, mint] = akaike(model,u,y',0,0);
%mint;
%modelo
nterms=10;
[m,x]=orthreg(model,ut,yt',[nterms 0],0);

%Structure and parameters identified
tetas=x(:,1);
model=m;

%Simulation of the systems
ysim=simodeld(model,tetas,uv,y(301:300+lagy)');

%NRMSE
numc=(yv-ysim')*(yv-ysim')';
denc=(yv-mean(ysim'))*(yv-mean(ysim'))';
nrmse=sqrt(numc)/sqrt(denc)

%Comparison
figure(1);
plot(yv,'k');
hold on
plot(ysim);
hold off
xlabel('k')
legend('System','Model')

