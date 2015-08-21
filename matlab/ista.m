function [xx,stat]=ista(A,ytr,lambda,L,varargin)

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

xx=zeros(n,1);

fval=nan*ones(1,opt.maxiter);
dval=nan*ones(1,opt.maxiter);
dist=nan*ones(1,opt.maxiter);
time=nan*ones(1,opt.maxiter);
res =nan*ones(1,opt.maxiter);

info.ginfo=0;

time0=cputime;

for kk=1:opt.maxiter
  [floss,gloss]=loss_sqp(A(xx),ytr);
  fval(kk)=floss+lambda*sum(abs(xx));

  if fval(kk)<=opt.tol
    break;
  end
  
  xx=softth(xx-AT(gloss)/L, lambda/L);
    
  if ~isempty(opt.w0)
    dist(kk)=norm(xx-opt.w0);
  end
  time(kk)=cputime-time0;
  
  if opt.display
    fprintf('[%d] fval=%g res=%g dist=%g L=%g\n', kk, fval(kk), res(kk), ...
            dist(kk),L);
  end
end

fval(kk+1:end)=[];
time(kk+1:end)=[];
dist(kk+1:end)=[];


stat=struct('fval',fval,...
            'dist',dist,...
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
