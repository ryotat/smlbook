m = 1024; n = 4096; k = round(0.04*n);
nrep=10;

methods={'fista','dadmm','dal'};
lambda=exp(linspace(log(0.001),log(1),20));

time=zeros(nrep,length(lambda),length(methods));
fval=zeros(nrep,length(lambda),length(methods));
res=zeros(nrep,length(lambda),length(methods));
for ii=1:nrep
  A=randn(m,n);
  w0=randsparse(n,k); bb=A*w0+0.01*randn(m,1);
  for jj=1:length(methods)
    for kk=1:length(lambda)
      lmd=lambda(kk)*max(abs(A'*bb));
      switch(methods{jj})
       case 'fista'
        [ww,stat]=fista(A, bb, lmd, 'tol', 1e-3, 'display',0);
        fval(ii,kk,jj)=stat.fval(end);
        res(ii,kk,jj)=stat.res(end);
       case 'dadmm'
        [ww,stat]=dadmm(A, bb, lmd,0);
        fval(ii,kk,jj)=stat.fval(end);
        res(ii,kk,jj)=1-stat.dval(end)/stat.fval(end);
       case 'dal'
        [ww,stat]=dalsql1(zeros(n,1), A, bb, lmd,'display',1);
        fval(ii,kk,jj)=stat.fval(end);
        res(ii,kk,jj)=stat.res(end);
      end
      time(ii,kk,jj)=stat.time(end);
      fprintf('method=%s lmd=%g fval=%g time=%g\n', methods{jj},...
              lmd, fval(ii,kk,jj), time(ii,kk,jj));
    end
  end
end
