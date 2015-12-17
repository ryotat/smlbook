function [ww,stat]=dadmm(X, yy, lambda, verbose)

eta=1;
maxiter=1000;
tol=1e-3;

if ~exist('verbose','var')
  verbose=1;
end


[n,d]=size(X);


% fprintf('Computing the Cholesky factorization...\n');
R=chol(eta*X*X'+lambda*eye(n));

alpha=zeros(n,1);
w0=zeros(d,1);
ww=zeros(d,1);


fval=zeros(1,maxiter);
dval=zeros(1,maxiter);
time=zeros(1,maxiter);
time0=cputime;
for kk=1:maxiter
  % alpha update
  alpha=R\(R'\(yy-X*(2*ww-w0)));
  
  % w update
  vv=X'*alpha;
  w0=ww+eta*(vv);
  ww=l1_softth(w0,1);

  fval(kk)=norm(yy-X*ww)^2/(2*lambda)+sum(abs(ww));
  alpha1=alpha/max(1,max(abs(vv)));
  dval(kk)=-lambda/2*norm(alpha1)^2+alpha1'*yy;
  time(kk)=cputime-time0;

  if verbose
    fprintf('kk=%d fval=%g dval=%g nnz=%d\n',kk,fval(kk),dval(kk),full(sum(ww~=0)));
  end
  
    if 1-dval(kk)/fval(kk)<tol
    break;
  end
end

fval(kk+1:end)=[];
dval(kk+1:end)=[];
time(kk+1:end)=[];

stat=struct('fval',fval,'dval',dval,'time',time);

function [vv,ss]=l1_softth(vv,lambda)

n = size(vv,1);

Ip=find(vv>lambda);
In=find(vv<-lambda);

vv=sparse([Ip;In],1,[vv(Ip)-lambda;vv(In)+lambda],n,1);

ss=abs(vv);