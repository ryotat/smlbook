function [xx,stat]=irlrl1(A,ytr,lambda,varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt,'maxiter',100,'iter',0,'tol',1e-3,'fval_target',[]);

[m,n]=size(A);

xx_save   = nan*ones(n,opt.maxiter);
time      = nan*ones(1,opt.maxiter);
fval_save = nan*ones(1,opt.maxiter);
xx=randn(n,1);
time0=cputime;
dval=inf;
for kk=1:opt.maxiter
  dd=abs(xx);
  
  fun=@(xx)objlrl2(xx,A*spdiag(sqrt(dd)),ytr,lambda);
  [x1,stat] = lbfgs(fun,xx,-inf*ones(n,1),inf*ones(n,1),[],[],'epsg',1e-3);
  xx = sqrt(dd).*x1;

  fval = stat.fval-0.5*lambda*sum(x1.^2) + lambda*sum(abs(xx));

  %dval = min(dval,evaldual(@loss_lrd, -stat.gloss, A, ytr, lambda));
  gap  = (fval-(-dval))/fval;

  
  fval_save(kk)=fval;
  time(kk)=cputime-time0;
  res(kk)=gap;
  xx_save(:,kk) = xx;
  fprintf('[[%d]] fval=%g sum(abs(xx))=%g gap=%g\n',kk,fval,sum(abs(xx)),gap);

  if ~isempty(opt.fval_target) && fval<=opt.fval_target
    break;
  end
  
  if gap<=opt.tol
    break;
  end
end

if opt.iter
  xx=xx_save;
end

time(kk+1:end)=[];
fval_save(kk+1:end)=[];

stat=struct('niter',kk,'time',time,'fval',fval_save,'res',res);

function [fval, gg, gloss]=objlrl2(xx,A,ytr,lambda)

[floss,gloss] = loss_lrp(A*xx,ytr);

fval = floss+0.5*lambda*sum(xx.^2);
gg   = A'*gloss+lambda*xx;

function [floss, gloss]=loss_lrp(zz, yy)

zy      = zz.*yy;
z2      = 0.5*[zy, -zy];
outmax  = max(z2,[],2);
sumexp  = sum(exp(z2-outmax(:,[1,1])),2);
logpout = z2-(outmax+log(sumexp))*ones(1,2);
pout    = exp(logpout);

floss   = -sum(logpout(:,1));
gloss   = -yy.*pout(:,2);

function [floss, gloss] = loss_lrd(aa, yy)

mm=length(aa);

gloss=nan*ones(mm,1);

ya = aa.*yy;

I = find(0<ya & ya<1);
floss = sum((1-ya(I)).*log(1-ya(I))+ya(I).*log(ya(I)));
gloss(I) = yy(I).*log(ya(I)./(1-ya(I)));

function dval = evaldual(fun, aa, A, yy, lambda)

mm=length(aa);

dnm = max(abs(A'*aa));

if dnm>0
  aa  = min(1, lambda/dnm)*aa;
end

dval = fun(aa, yy);

function [xx, status] = lbfgs(fun, xx, ll, uu, Ac, bc, varargin)

opt=propertylist2struct(varargin{:});
opt=set_defaults(opt, 'm', 6,...
                      'ftol', 1e-5, ...
                      'maxiter', 0,...
                      'max_linesearch', 50,...
                      'display', 0,...
                      'epsg', 1e-5);


if ischar(fun)
  fun = {fun};
end

nn = size(xx,1);

t0 = cputime;

% Limited memory
lm = repmat(struct('s',zeros(nn,1),'y',zeros(nn,1),'ys',0,'alpha',0),[1, opt.m]);

[fval,gg,gloss]=fun(xx);


% The initial step is gradient
dd = -gg;

kk = 1;
stp = 1/norm(dd);

bResetLBFGS = 0;
ixend = 1;
bound = 0;
while 1
  fp = fval;
  xxp = xx;
  ggp = gg;

  % Perform line search
  [ret, xx,fval,gg,gloss,stp]=...
      linesearch_backtracking(fun, xx, ll, uu, Ac, bc, fval, gg, dd, stp, opt, varargin{:});
  
  if ret<0
    break;
  end

  % Progress report
  gnorm = norm(gg);
  if opt.display>1
    fprintf('[%d] xx=[%g %g...] fval=%g gnorm=%g step=%g\n',kk,xx(1),xx(2),fval,gnorm,stp);
  end

  if gnorm<opt.epsg
    if opt.display>1
      fprintf('Optimization success!\n');
    end
    ret=0;
    break;
  end
  
  if kk==opt.maxiter
    if opt.display>0
      fprintf('Maximum #iterations=%d reached.\n', kk);
    end
    ret = -3;
    break;
  end

  % L-BFGS update
  if opt.m>0
    lm(ixend).s = xx-xxp;
    lm(ixend).y = gg-ggp;
    ys = lm(ixend).y'*lm(ixend).s; yy = sum(lm(ixend).y.^2);
    lm(ixend).ys  = ys;
  else
    ys = 1; yy = 1;
  end
  
  bound = min(bound+1, opt.m);
  ixend = (opt.m>0)*(mod(ixend, opt.m)+1);

  % Initially set the negative gradient as descent direction
  dd = -gg;
  
  jj = ixend;
  for ii=1:bound
    jj = mod(jj + opt.m -2, opt.m)+1;
    lm(jj).alpha = lm(jj).s'*dd/lm(jj).ys;
    dd = dd -lm(jj).alpha*lm(jj).y;
  end

  dd = dd *(ys/yy);
  
  for ii=1:bound
    beta = lm(jj).y'*dd/lm(jj).ys;
    dd = dd + (lm(jj).alpha-beta)*lm(jj).s;
    jj = mod(jj,opt.m)+1;
  end

  stp = 1.0;
  
  kk = kk + 1;
end

status=struct('ret', ret,...
              'kk', kk,...
              'fval', fval,...
              'gg', gg,...
              'time', cputime-t0,...
              'opt', opt,...
              'gloss',gloss);


function [ret, xx, fval, gg, gloss, step]...
    =linesearch_backtracking(fun, xx, ll, uu, Ac, bc, fval, gg, dd, step, opt, varargin)

floss=0;
gloss=zeros(size(gg));

dginit=gg'*dd;

if dginit>=0
  if opt.display>0
    fprintf('dg=%g is not a descending direction!\n', dginit);
  end
  step = 0;
  ret = -1;
  return;
end

Ip=find(dd>0);
In=find(dd<0);
step=min([step, 0.999*min((xx(In)-ll(In))./(-dd(In))), 0.999*min((uu(Ip)-xx(Ip))./dd(Ip))]);


xx0 = xx;
f0  = fval;
gg0 = gg;
cc = 0;

if opt.display>2
  fprintf('finit=%.20f\n',f0);
end

while cc<opt.max_linesearch
  ftest = f0  + opt.ftol*step*dginit;
  xx    = xx0 + step*dd;

  if ~isempty(Ac)
    bineq = all(Ac*xx<=bc);
  else
    bineq = true;
  end

  if bineq && all(xx>=ll) && all(xx<=uu)
    [fval, gg, gloss]=fun(xx);
    
    if fval<=ftest
      break;
    end
  else
    fval = inf;
  end
  if opt.display>2
    fprintf('[%d] step=%g fval=%.20f > ftest=%.20f\n', cc, step, fval, ftest);
  end
  
  step = step/2;
  cc = cc+1;
end

if cc==opt.max_linesearch
  if opt.display>0
    fprintf('Maximum linesearch=%d reached\n', cc);
  end
  xx   = xx0;
  [fval, gg, gloss]=fun(xx);
  step = 0;
  ret = -2;
  return;
end


ret = 0;
