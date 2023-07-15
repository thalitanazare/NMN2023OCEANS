function y=fpoints(model,x0)
% function y=fpoints(model,x0) returns the fixed points
%            of a NARMA model
%
% On entry
%       model  -  model must contain *only* output terms (It is a time 
%                 serie model)
%	x0     -  model parameters
%
% On return
%       y      -  fixed points of model [x0,model]   
%    
% Observation: It's implicit that all process terms came before a possible 
%              noise model !!!   

% Giovani Guimarães Rodrigues
% CPDEE - UFMG 03/06/97

if nargin ~= 2
   error('fpoints requires 2 input arguments.');
end;

if nargout ~= 1
   error('fpoints requires 1 output argument.');
end;

[a,nsuby]=size(x0);

if nsuby ~= 1
   error('Only SISO models');
end;

[nt,b]=size(model);
degree=floor(b/nsuby);

if (b ~= degree*nsuby)
   error('model is incompatible (nsuby).');
end;

if (a ~= nt)
   error('model and coefficients are incompatible (rows).');
end;

[npr,nno,lag,ny,nu,ne]=get_info(model);

% Calculations

ccly=zeros(degree,1);
ccly(1,1)=-1;
cclc=0;

for i=1:npr,
  count1=find(model(i,:)>2000);
  if count1 
     model(i,:)=zeros(1,degree);
  end;
end;

for i=1:npr,
    count1=find(model(i,:));
    if (isempty(count1))      %    if (count1 == []) modificado por Erivelton em 01/12/2000
       cclc=cclc+x0(i);
    else 
       ccly(length(count1),1)=ccly(length(count1),1)+x0(i);
    end;
end;

for i=1:degree,
vet(i)=ccly(degree-i+1,1);
end;
vet=[vet cclc];
y=roots(vet);
