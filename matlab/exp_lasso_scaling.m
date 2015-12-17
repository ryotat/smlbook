nrep=100;
sigma=0.01;
k=10;

ds = 100:100:1000;
ns = 100:10:200;

err=zeros(length(ns), length(ds), nrep);

for ll=1:nrep
  for ii=1:length(ns)
    n=ns(ii);
    for jj=1:length(ds)
      d=ds(jj);
      X=randn(n,d);
      w0=randsparse(d,k);
      yy=X*w0+sigma*randn(n,1);
      lambda=sigma*sqrt(log(d)/n);
      [ww,stat]=dalsql1(zeros(d,1), X, yy, n*lambda,'display',0);
      err(ii,jj,ll)=norm(ww-w0);
      fprintf('n=%d d=%d error=%g\n', n, d, err(ii,jj));        
    end
  end
  subplot(1,2,1);
  imagesc(ds, ns, mean(err(:,:,1:ii),3));
  colormap jet
  hold on;
  plot(ds, 20*log(ds), 'm--', 'linewidth', 2);
  plot(ds, 25*log(ds), 'm--', 'linewidth', 2);
  plot(ds, 30*log(ds), 'm--', 'linewidth', 2);
  hold off;
  set(gca,'fontsize',14,'ydir','normal')
  colorbar;
  
  xlabel('d');
  ylabel('n');
  
  title('Average error ||w^-w*||','interpreter','none');
  
  subplot(1,2,2);
  ix=[1,2,4,8];
  h=errorbar_logsafe(ns'*(1./log(ds(ix))), mean(err(:,ix,1:ii),3), std(err(:,ix,1:ii),[],3));
  set(h,'linewidth',2);
  grid on;
  set(gca,'fontsize',14);
  xlabel('n/log(d)');
  ylabel('Error ||w^-w*||','interpreter','none');
  legend(cellfun(@(x)sprintf('d=%d',x), num2cell(ds(ix)), ...
      'uniformoutput',0));
  set(gcf,'name',sprintf('nrep=%d',ll));
  drawnow;
end

