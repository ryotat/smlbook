function [S,L,fval,err]=fwrpca(Y, C, theta,S0,L0)

maxiter=20000;

[m,n]=size(Y);

S=zeros(m,n);
L=zeros(m,n);

for kk=1:maxiter-1
  G = Y-S-L;    % negative gradient
  [mm,ix]=max(abs(G(:))); % pick a basis
  ss=norm(G);
  D=zeros(m,n);
  if mm>ss/theta
    D(ix)=sign(G(ix))*C; D=D-(S+L);
    gamma=D(:)'*G(:)/norm(D(:))^2;
    S=(1-gamma)*S; S(ix)=S(ix)+gamma*sign(G(ix))*C;
    L=(1-gamma)*L;
  else
    [U,ss,V]=pca(G,1,10);
    D=C/theta*U*V'-(S+L);
    gamma=D(:)'*G(:)/norm(D(:))^2;
    S=(1-gamma)*S;
    L=(1-gamma)*L+gamma*C/theta*U*V';
  end
  % fline=@(x)0.5*norm(G-x*D,'fro')^2;
  % gms=linspace(0,1,1000);
  % mf=min(arrayfun(fline, gms));
  fval(kk)=0.5*norm(Y-S-L,'fro')^2;
  err(kk)=norm(S(:)-S0(:))^2+norm(L(:)-L0(:))^2;
  if floor(kk/100)*100==kk
    fprintf('kk=%d gamma=%g norm=%g loss=%g\n', kk, gamma,...
            sum(abs(S(:)))+theta*sum(svd(L)),...
              fval(kk));
  end
  if fval(kk)<1e-6
    break;
  end
end