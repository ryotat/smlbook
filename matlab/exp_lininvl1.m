ds=200; % 100:100:2000;
ks=1:40;
fracs=0.025:0.025:1;

nrep=100;


dims=l1_statdim(ks,ds);
delta=0.05;
a=4*sqrt(log(4/delta));

for ii=1:nrep
  for jj=1:length(ds)
    d=ds(jj);
    for kk=1:length(fracs)
      n=round(fracs(kk)*d);
      X=randn(n,d);
      for ll=1:length(ks)
        w0=randsparse(d,ks(ll));
        [ww,stat]=dadmm(X, X*w0, 1e-4,0);
        err(ii,jj,kk,ll)=norm(w0-ww);
      end
      fprintf('d=%d n=%d err=%s\n',d,n,printvec(err(ii,jj,kk,:)));
    end
  end
  
  errm=shiftdim(mean(err<1e-2,1)); 
  imagesc(ks, fracs*ds, errm)
  set(gca,'ydir','normal')
  colormap gray
  hold on;
  h=plot(ks, dims, 'm-',...
      ks, ks*log(ds), 'c--', 'linewidth',2);
  set(gca,'fontsize',14);
  xlabel('Number of nonzeros');
  ylabel('Number of samples');
  colorbar;
  legend(h,'Statistical dimension','k*log(d)',...
      'Location','NorthWest')
  set(gcf,'name',sprintf('nsample=%d',ii));
  drawnow;
end

fracinf=[fracs inf];
thr=zeros(length(ds),length(ks));
for ii=1:length(ds)
  thr(ii,:)=fracinf(sum(shiftdim(errm(ii,:,:))<=0.5)+1);
end
