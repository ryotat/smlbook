ds=200; % 100:100:2000;
ks=1:40;
fracs=0.025:0.025:1;

nrep=100;

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
end

errm=shiftdim(mean(err<1e-2)); 
fracinf=[fracs inf];
thr=zeros(length(ds),length(ks));
for ii=1:length(ds)
  thr(ii,:)=fracinf(sum(shiftdim(errm(ii,:,:))<=0.5)+1);
end

d=ds;
dims=l1_statdim(ks,d);
delta=0.05;
a=4*sqrt(log(4/delta));
subplot(1,2,1);
imagesc(ks, fracs*ds, errm)
set(gca,'ydir','normal')
colormap gray
hold on;
plot(ks, dims, 'm-', 'linewidth',2);
set(gca,'fontsize',14);
xlabel('Number of nonzeros');
ylabel('Number of samples');
colorbar;


