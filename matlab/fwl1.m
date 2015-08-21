function [W,I,D,fval]=fwl1(X, yy, C)

maxiter=1000;

[n,d]=size(X);

if size(yy,1)~=n
  error('size of X and Y should agree.');
end

W=zeros(d,maxiter);
I=zeros(1,maxiter);
D=zeros(1,maxiter);
ww=zeros(d,1);
for kk=1:maxiter-1
  gg = X'*(yy-X*ww);    % negative gradient
  [mm,ix]=max(abs(gg)); % pick a basis
  gamma=2/(kk+2);
  ww=(1-gamma)*ww;
  ww(ix)=ww(ix)+gamma*sign(gg(ix))*C;
  W(:,kk+1)=ww;
  I(kk)=ix;
  D(kk)=mm/norm(gg);
  fval(kk)=0.5*norm(X*ww-yy)^2;
  fprintf('kk=%d norm=%g loss=%g\n', kk, sum(abs(ww)),fval(kk));
end