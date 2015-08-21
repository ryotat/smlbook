function [S,L,A,fval,res, err]=rpca_admm(Y, lambda, theta, indices, imsz, S0, L0)

if ~exist('indices','var')
  indices=[];
end
if ~exist('imsz','var')
  imsz=[];
end

eta=0.1*std(Y(:));
maxiter=1000;

[m,n]=size(Y);

Zs=zeros(m,n);
Zl=zeros(m,n);
S=zeros(m,n);
L=zeros(m,n);
A=zeros(m,n);

nsv=10;
for kk=1:maxiter
  A=1/(lambda+2*eta)*(Y-S-L+eta*(Zs+Zl));

  Sold=S; Lold=L;
  S=softthl1(S+eta*A,eta);
  [L,ss,nsv]=softth(L+eta*A,eta*theta,nsv);
  Zs=(Sold-S)/eta+A;
  Zl=(Lold-L)/eta+A;
  
  fval(kk)=0.5*norm(Y(:)-S(:)-L(:))^2/lambda+sum(abs(S(:)))+theta*sum(svd(L));

%  if norm(Zl)>theta*(1+1e-3)
%    keyboard;
%  end
  ZZ=Zl/max(abs(Zl(:)));
  if kk==1 || floor(kk/10)*10==kk
    dval=lambda/2*norm(ZZ)^2-ZZ(:)'*Y(:);
  end
  res(kk)=1+dval/fval(kk);
  if exist('S0','var') && exist('L0','var')
    err(kk)=norm(S(:)-S0(:))^2+norm(L(:)-L0(:))^2;
  end
  if ~isempty(indices)
    len=length(indices);
    for ii=1:len
      subplot(2,len,ii);
      imagesc(reshape(L(:,indices(ii)),imsz)); colormap(gray);
      subplot(2,len,ii+len);
      imagesc(reshape(S(:,indices(ii)),imsz)); colormap(gray);
      drawnow;
    end
  end
  fprintf('kk=%d fval=%g rank=%d viol=%g res=%g\n', kk, fval(kk),...
          nsv, max(norm(A(:)-Zs(:)),norm(A(:)-Zl(:))), res(kk));
  if res(kk)<1e-3
    break;
  end
end
fval(kk+1:end)=[];
res(kk+1:end)=[];

if ~exist('S0','var') || ~exist('L0','var')
  err=[];
else
  err(kk+1:end)=[];
end


function vv=softthl1(ww,lambda);
I=abs(ww)>lambda;
vv=zeros(size(ww));
vv(I)=ww(I)-lambda*sign(ww(I));

