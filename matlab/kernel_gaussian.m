function K = kernel_gaussian(Xtr, Xte, sigma)

if ~exist('Xte','var') || isempty(Xte)
  Xte=Xtr;
end

m=size(Xtr,1);
n=size(Xte,1);

D = sum(Xtr.^2,2)*ones(1,n) - 2*Xtr*Xte' + ones(m,1)*sum(Xte.^2,2)';

K = exp(-D./(2*sigma^2));

