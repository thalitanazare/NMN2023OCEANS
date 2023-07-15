function [sigma, FP, fp, fpstd] = fixedp(y, L, delta, see, remove);

% Estimates fixed points using a 13-term nonlinear structure and 
% a time series.
% 
% [sigma, FP, fp, fpstd] = fixedp(y, L, delta, see, remove)
% Where:
% sigma: this matrix contains the cluster coefficients (one column
%	 for each cluster) as a function of the window (e.g. the
%	 first row corresponds to the first window of data used, etc.) 
% FP   : this matrix contains the 'local' estimated fixed points (one in each
%	 column) as a function of the window (e.g. the first row corresponds
%	 to the first window of data used, etc.). This matrix is useful to
%	 get plots.
% fp   : estimated fixed points. These values are obtained by taking the
%      : average values of the respective columns of FP.
% fpstd: standard deviation of estimates. 
% y    : the data (column vector)
% L    : window length (e.g. L= 200)
% delta: increment between windows (e.g. delta=5)
% see  : if see=1, plots will be shown
%
% How to remove a certain cluster:
%
% To remove a cluster from the regressor matrix, use the string 
% 'remove'. If this string is omitted from the input parameter list,
% no clusters are removed from the regressor matrix.
% '0', '2' and '3' denote constant, quadratic
% and cubic clusters respectily. 
%
% Examples: 
%  [sigma, FP] = fixed(y, 200, 5, 1); % this does not remove any cluster
%
%  [sigma, FP] = fixed(y, 200, 5, 1, '03'); % this removes the constant term
% 					    and all the cubic terms
%

% Written by Álvaro Souza
% UFMG, Belo Horizonte, BRAZIL, 1997 
% URL address: (http://www.cpdee.ufmg.br/~MACSIN)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tests and initial settings


y=y(:);


% Term cluster verification


regressors=0;

if nargin==4
   IFno=1; 
   remove='';
   regressors=13;
   IF0=0;
   IF2=0;
   IF3=0;
   IF23=0;
   a=2;
else
   IFno=0;
   end;


if nargin==5

% Verify if the user has mistakenly
% removed all clusters 
if length(remove)==3
if (remove=='023')|(remove=='032')
   disp('The cluster exclusion required will yield a trivial estimate. FP=0');
   FP=0;
   sigma='';
   return;
   end;
   end;


 IF0=sum(remove=='0');  % stores 1 if constant cluster will be deleted
 IF2=sum(remove=='2');  % stores 1 if quadratic cluster will be deleted
 IF3=sum(remove=='3');  % stores 1 if cubic cluster will be deleted
   
   a=2;  % stores 2 if constant term will not be deleted from PSI
   
   if IF0==1
     a=1; % stores 1 if constant term will be deleted from PSI
     IFno=1;
     regressors=13;
     end;

   if (IF2==1)&(IF3==1)
     regressors=5;
     IF2=0;
     IF3=0;
     IFno=0;
     IF23=1;  % stores 1 if quadratic and cubic clusters will be deleted
   else
     IF23=0;
     if IF2==1
       IFno=0;       
       IFno=0;
       regressors=9;
       end;
     if IF3==1
       IFno=0;
       regressors=9;
       end;
     end;

   end;


if regressors==0
   error('the parameter "remove" could not be interpreted!');
   end;

if IF0
   regressors=regressors-1;
   end;
   

b=a+1;   % variables used to build PSI 
c=b+1;
d=c+1;

% data length
N=length(y);	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start of algoritm
% The comments follow the steps suggested in (Aguirre & Souza, 1998)

%Step 1
   norma=max(abs(y));	
   y=y./norma;


% PSI allocation. If a=2, the first column 
% will be made up of ones.
PSI=ones(L, regressors); 


%Step 3
   Number_of_window=1;

for k=4: delta: N-L	%Steps 3 and 8



%Step 4


     % Same regressors used in numerical 
     % examples of (Aguirre & Souza, 1998) 
     % The algorithm is quite robust this choice
     % which was done arbitrarily!


if IFno
   
      %Linear terms
       PSI(:,a)=y(k:k+L-1);
       PSI(:,b)=y(k-1:k+L-2);
       PSI(:,c)=y(k-2:k+L-3);
       PSI(:,d)=y(k-3:k+L-4);
  
      %Quadratic terms
       PSI(:,d+1)=(PSI(:,a).^2);
       PSI(:,d+2)=(PSI(:,b).^2);
       PSI(:,d+3)=(PSI(:,c).*PSI(:,d));
       PSI(:,d+4)=(PSI(:,a).*PSI(:,b));
  

      %Cubic terms
       PSI(:,d+5)=(PSI(:,a).^3);
       PSI(:,d+6)=(PSI(:,c).^3);
       PSI(:,d+7)=(PSI(:,b).^2).*(PSI(:,a));
       PSI(:,d+8)=(PSI(:,b)).*(PSI(:,a)).*(PSI(:,c));

end;

if IF2 % only linear and cubic clusters are present apart from, perhaps, the
%	 constant term	
     
      %Linear terms
       PSI(:,a)=y(k:k+L-1);
       PSI(:,b)=y(k-1:k+L-2);
       PSI(:,c)=y(k-2:k+L-3);
       PSI(:,d)=y(k-3:k+L-4);
  
  
      %Cubic terms
       PSI(:,d+1)=(PSI(:,a).^3);
       PSI(:,d+2)=(PSI(:,c).^3);
       PSI(:,d+3)=(PSI(:,b).^2).*(PSI(:,a));
       PSI(:,d+4)=(PSI(:,b)).*(PSI(:,a)).*(PSI(:,c));

end;

if IF3 % only linear and quadratic clusters are present apart from, perhaps, the
%	 constant term	
     
      %Linear terms
       PSI(:,a)=y(k:k+L-1);
       PSI(:,b)=y(k-1:k+L-2);
       PSI(:,c)=y(k-2:k+L-3);
       PSI(:,d)=y(k-3:k+L-4);
  
      %Quadratic terms
       PSI(:,d+1)=(PSI(:,a).^2);
       PSI(:,d+2)=(PSI(:,b).^2);
       PSI(:,d+3)=(PSI(:,c).*PSI(:,d));
       PSI(:,d+4)=(PSI(:,a).*PSI(:,b));
  
end;

if IF23 % only the linear cluster is present apart from, perhaps, the
%	  constant term	
     
      %Linear terms
       PSI(:,a)=y(k:k+L-1);
       PSI(:,b)=y(k-1:k+L-2);
       PSI(:,c)=y(k-2:k+L-3);
       PSI(:,d)=y(k-3:k+L-4);
  
end;


      % Vector y
       Y=y(k+1:k+L);


%Step 5
   teta=(inv(PSI'*PSI)*PSI')*Y;

%Step 6 - Here we store the cluster coefficients in sigma

   sigma(Number_of_window, 1)=teta(1);
   if IF0 
      sigma(Number_of_window, 1)=0;
   else
      sigma(Number_of_window, 1)=teta(1);
   end;
  
if IFno
   sigma(Number_of_window, 2)=sum(teta(a:d));
   sigma(Number_of_window, 3)=sum(teta(d+1:d+4));
   sigma(Number_of_window, 4)=sum(teta(d+5:d+8));
end;

if IF2
   sigma(Number_of_window, 2)=sum(teta(a:d));
   sigma(Number_of_window, 3)=0;
   sigma(Number_of_window, 4)=sum(teta(d+1:d+4));
end;

if IF3
   sigma(Number_of_window, 2)=sum(teta(a:d));
   sigma(Number_of_window, 3)=sum(teta(d+1:d+4));
   sigma(Number_of_window, 4)=0;
end;

if IF23
   sigma(Number_of_window, 2)=sum(teta(a:d));
   sigma(Number_of_window, 3)=0;
   sigma(Number_of_window, 4)=0;
end;



%Step 7
   FP(Number_of_window,:) = roots( [sigma(Number_of_window, 4) sigma(Number_of_window, 3) sigma(Number_of_window, 2)-1 sigma(Number_of_window, 1)] )';


Number_of_window=Number_of_window+1;


end;


% undo the normalization performed in step 1
FP=FP*norma;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Warning


% Complex parts test
Mfp=mean(FP);

   if (imag(Mfp)==0)
   else
     disp('WARNING! Complex parts of estimates will be ignored in the graph.');
     end;

% cleaning up 'complex fixed points' if they are not too many. If they ARE
% too many this is an indication that estimation is probably inaccurate or
% wrong.

[linhas colunas]=size(FP);
for i=1:colunas
  I=find(imag(FP(:,i))==0);
  if length(I)<linhas*0.2
    disp('For most windows a complex fixed point was estimated. This will not be eliminated');
  else
    FP=FP(I,:);
  end;
end;


FP=sort(FP')';

fp=mean(real(FP));
fpstd=std(real(FP));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots

if see==1 %plot graphs only if required

whitebg('white');


%Term clusters graph
title('Term clusters graph');
subplot(221);
if IF0~=1
  plot(sigma(:, 1), 'k');
  axis([0 Number_of_window min(sigma(:, 1))-1 max(sigma(:, 1))+1]);
  grid;
  title('Constant term');
else
  plot(0,0, 'ok');
  title('No constant term');
end;

subplot(222);
plot(sigma(:, 2), 'k');
axis([0 Number_of_window min(sigma(:, 2))-1 max(sigma(:, 2))+1]);
grid;
title('coefficient of the linear cluster');

subplot(223);
if IF2~=1
  plot(sigma(:, 3), 'k');
  axis([0 Number_of_window min(sigma(:, 3))-1 max(sigma(:, 3))+1]);
  grid;
  title('coefficient of the quadratic cluster');
  xlabel('Number of windows');
else
  plot(0,0, 'ok');
  title('No quadratic cluster');
end;
xlabel('Number of windows');

subplot(224);
if IF3~=1
  plot(sigma(:, 4), 'k');
  axis([0 Number_of_window min(sigma(:, 4))-1 max(sigma(:, 4))+1]);
  grid;
  title('coefficient of the cubic cluster');
  xlabel('Number of windows');

else
  plot(0,0, 'ok');
  title('No cubic cluster');
  xlabel('Number of windows');
end;

if IF23==1
  subplot(223);
  plot(0,0, 'ok');
  title('No quadratic cluster');
  xlabel('Number of windows');
  subplot(224);
  plot(0,0, 'ok');
  title('No cubic cluster');
  xlabel('Number of windows');
end;

%Fixed points graph
figure
hold on
title('Estimated Fixed Points (-) Data Range limits (- -)');
plot(real(FP), 'k');
plot((1:Number_of_window), norma*max(y).*ones(1,Number_of_window), ':k');
plot((1:Number_of_window), norma*min(y).*ones(1,Number_of_window), ':k');
LL=max(y)-min(y);
axis([0 Number_of_window norma*min(y)-0.2*norma*LL norma*max(y)+0.2*norma*LL]);
hold off

end; %plot graphs only if required
