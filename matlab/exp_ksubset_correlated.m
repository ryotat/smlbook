d=200;

k=10;

ns=10:10:250;
nte=1000;

% Set one to visualize weights (Fig. 3.5)
visualize_weights = 0;

% Number of replications (ignored if visualize_weights=1)
nrep=100;


sigma=1;

methods={'l1','l2','largestk','2step','optimal'};
lambdas=exp(linspace(log(1e+6),log(1e-6),20));
lambdasl1=exp(linspace(log(1e+3),log(1e-3),20));

for ii=1:nrep
  w0=[randn(k,1); zeros(d-k,1)];
  v0=randn(k,1); v0=v0-w0(1:k)'*v0/norm(w0)^2*w0(1:k); v0=v0/norm(v0);
  C=v0*v0'+0.1*eye(k); C=C*k/trace(C);
  Xte=[randn(nte,k)*sqrtm(C), randn(nte,d-k)];
  yte=Xte*w0;
  if visualize_weights
    subplot(2,(length(methods)+1)/2,1);
    stem(w0(1:100));
    ylim([-1.5 1.5]);
    grid on;
    title(sprintf('Truth (supp=%d)',k),...
          'fontsize',14);
    ns=150;
  end
  for jj=1:length(ns)
    n=ns(jj);
    X=[randn(n,k)*sqrtm(C), randn(n,d-k)];
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
        W=continuation(@(x0,lmd)dalsql1(x0, X, yy, lmd, 'display', 0),...
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
      eall=sum(bsxfun(@minus, Xte*W, yte).^2)/nte;
      [mm,ix]=min(eall);
      err(ii,jj,kk)=mm;
      memo(ii,jj,kk)=struct('eall',eall,'ix',ix);
      if visualize_weights
        % visualization
        subplot(2,(length(methods)+1)/2,kk+1);
        stem(W(1:100,ix));
        title(sprintf('%s (supp=%d)',methods{kk},sum(abs(W(:,ix))>0)),...
              'fontsize',14);
        grid on;
        ylim([-1.5 1.5]);
      end
    end
    fprintf('rep=%d n=%d: %s\n', ii, n, printvec(err(ii,jj,:)));
  end
  if visualize_weights
      break;
  else
      h=errorbar(ns'*ones(1,5), shiftdim(mean(err,1)), shiftdim(std(err,[],1))/sqrt(nrep));
      set(h,'linewidth',2);
      hold on; plot(xlim, 0.5*[1 1], '--','color',[.8 .8 .8])
      grid on;
      set(gca,'fontsize',14);
      legend('L1', 'L2', 'Largest-k', '2steps', 'Optimal');
      
      xlabel('Number of samples');
      ylabel('Normalized error');
      set(gcf,'name',sprintf('nrep=%d', ii));
      hold off;
      drawnow;
  end
end
