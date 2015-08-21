d=200;

k=10;

ns=10:10:200;

nrep=10;
sigma=1;

methods={'optimal','l1','l2','largestk','2step'};
lambdas=exp(linspace(log(1e+6),log(1e-6),20));
lambdasl1=exp(linspace(log(1e+3),log(1e-3),20));
for ii=1:nrep
  w0=[randn(k,1); zeros(d-k,1)];
  for jj=1:length(ns)
    n=ns(jj);
    % X=[randn(n,k)/sqrt(k), randn(n,d-k)];
    X=randn(n,d);
    yy=X*w0+sigma*randn(n,1);
    
    for kk=1:length(methods)
      fprintf('rep=%d n=%d method=%s\n', ii, n, methods{kk});
      switch(methods{kk})
       case 'l2'
        W=continuation(@(x0,lmd)(X'*X+lmd*eye(d))\(X'*yy),...
                       randn(d,1), lambdas);
       case 'optimal'
        Xk=X(:,1:k);
        W=continuation(@(x0,lmd)[(Xk'*Xk+lmd*eye(k))\(Xk'*yy); zeros(d-k,1)],...
                       randn(d,1), lambdas);
       case 'l1'
        W=continuation(@(x0,lmd)dalsql1(x0, X, yy, lmd),...
                       randn(d,1), lambdasl1*sqrt(n));
       case 'largestk'
        W=continuation(@(x0,lmd)(X'*X+lmd*eye(d))\(X'*yy),...
                       randn(d,1), lambdas);
        th=kmax(abs(W),k);
        W(bsxfun(@lt, abs(W), th))=0;
       case '2step'
        corr=yy'*X;
        I=abs(corr)>=kmax(abs(corr)',k);
        Xk=X(:,I);
        W=zeros(d,length(lambdas));
        W(I,:)=continuation(@(x0,lmd)(Xk'*Xk+lmd*eye(k))\(Xk'*yy),...
                            randn(k,1), lambdas);
      end
      eall=sum(bsxfun(@minus, W, w0).^2);
      [mm,ix]=min(eall);
      err(ii,jj,kk)=mm;
      memo(ii,jj,kk)=struct('eall',eall,'ix',ix);
    end
    fprintf('rep=%d n=%d: %s\n', ii, n, printvec(err(ii,jj,:)));
  end
end

