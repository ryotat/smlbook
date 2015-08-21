function [xx,stat]=fista(A,ytr,lambda,varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt, 'eta',2,'tol',0,'w0',[],'maxiter',1000,'display',1);

if isnumeric(A)
  [m,n]=size(A);
  Atmp=A';
  A=@(x)A*x;
  AT=@(y)Atmp*y;
  clear Atmp;
else
  AT=A{2}; m=A{3}; n=A{4};
  A=A{1};
end

tt=1;
L =ones(1,opt.maxiter);

xx=zeros(n,1);
yy=xx;

fval=nan*ones(1,opt.maxiter);
dval=nan*ones(1,opt.maxiter);
dist=nan*ones(1,opt.maxiter);
time=nan*ones(1,opt.maxiter);
res =nan*ones(1,opt.maxiter);

info.ginfo=0;

time0=cputime;

[floss,gloss]=loss_sqp(A(xx),ytr);
fval(1)=floss/lambda+sum(abs(xx));

if ~isempty(opt.w0)
  dist(1)=norm(xx-opt.w0);
end
time(1)=cputime-time0;

% Check duality gap
alpha1=(-gloss)/max(1,max(abs(AT(gloss))));
dval(1)=-lambda/2*norm(alpha1)^2+alpha1'*ytr;
res(1) = 1-dval(1)/fval(1);

kk=1;
while res(kk) > opt.tol % fval(kk)>opt.tol
  if opt.display
    fprintf('[%d] fval=%g res=%g dist=%g L=%g\n', kk, fval(kk), res(kk), ...
            dist(kk),L(kk-(kk>1)));
  end
  
  fval(kk+1)=inf; qval=0;
  if kk>1
    L(kk)=L(kk-1);
  end
  while 1
    Ayy=A(yy);
    [floss,gloss]=loss_sqp(Ayy,ytr);
    Atgg = AT(gloss);
    xx1=softth(yy-Atgg/L(kk), lambda/L(kk));
    
    Axx1=A(xx1);
    fval(kk+1)=loss_sqp(Axx1,ytr)/lambda+sum(abs(xx1));
    qval=floss+gloss'*(Axx1-Ayy)+0.5*L(kk)*norm(xx1-yy)^2+lambda*sum(abs(xx1));
if isnan(qval)
  keyboard;
end

    
    if fval(kk+1)<qval
      break;
    end
    if opt.display
      fprintf('fval=%g qval=%g\n',fval(kk+1),qval);
    end
    L(kk)=L(kk)*opt.eta;
  end
  
  tt1 = (1+sqrt(1+4*tt^2))/2;
  
  yy = xx1 + (tt-1)/tt1*(xx1-xx);

  xx=xx1;
  tt=tt1;

  kk=kk+1;

  % Check duality gap
  alpha1=(-gloss)/max(1,max(abs(Atgg)));
  dval(kk)=-lambda/2*norm(alpha1)^2+alpha1'*ytr;
  res(kk) = 1-dval(kk)/fval(kk);
  
  if ~isempty(opt.w0)
    dist(kk)=norm(xx-opt.w0);
  end
  time(kk)=cputime-time0;
  
  if kk==opt.maxiter
    break;
  end
end

fval(kk+1:end)=[];
time(kk+1:end)=[];
dist(kk+1:end)=[];
res(kk+1:end)=[];
L(kk+1:end)=[];

stat=struct('fval',fval,...
            'dist',dist,...
            'L',L,...
            'res',res,...
            'opt',opt,...
            'time',time);




function vv=softth(vv,lambda)
n = size(vv,1);

Ip=find(vv>lambda);
In=find(vv<-lambda);

vv=sparse([Ip;In],1,[vv(Ip)-lambda;vv(In)+lambda],n,1);



% $$$ function gg=fix_grad(xx, gg, lambda)
% $$$ 
% $$$ % gg  =A'*gg+lambda*sign(xx);
% $$$ 
% $$$ I1=find(xx==0 & gg>0);
% $$$ I2=find(xx==0 & gg<0);
% $$$ 
% $$$ gg(I1)=gg(I1)+max(-lambda, -gg(I1));
% $$$ gg(I2)=gg(I2)+min(lambda, -gg(I2));
% $$$ 

function [floss, gloss]=loss_lrp(zz, yy)

zy      = zz.*yy;
z2      = 0.5*[zy, -zy];
outmax  = max(z2,[],2);
sumexp  = sum(exp(z2-outmax(:,[1,1])),2);
logpout = z2-(outmax+log(sumexp))*ones(1,2);
pout    = exp(logpout);

floss   = -sum(logpout(:,1));
gloss   = -yy.*pout(:,2);

function dval = evaldual(aa, ATaa, yy, lambda)

mm=length(yy);

dnm = max(abs(ATaa));

if dnm>0
  aa  = min(1, lambda/dnm)*aa;
end

ya=yy.*aa;

I = find(0<ya & ya<1);
dval = sum((1-ya(I)).*log(1-ya(I))+ya(I).*log(ya(I)));
