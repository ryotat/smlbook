n=10;
d=10;
Xogn=(1:n)'/n;
ftrue=@(X)100*(X-0.2).*(X-0.5).*(X-0.8);

tt=(0:0.1:n+1)'/n; Itest=tt<=1.0; ttest=tt(Itest);
T=bsxfun(@power, tt, 0:d);
ntest=size(T,1);

ps=1:10;
lmds=exp(linspace(log(1e-8),log(1e-2),10));

nrep=1000;
for kk=1:nrep
  noise(:,kk)=randn(n,1);
  Y=ftrue(Xogn)+noise(:,kk);

  X=bsxfun(@power, Xogn, 0:d);

  w=X\Y;

  for ii=1:length(ps)
    p=ps(ii);
    w_poly=X(:,1:p+1)\Y;
    res=(T(Itest,1:p+1)*w_poly-ftrue(ttest)).^2;
    err_poly(kk,ii)=sum((res(1:end-1)+res(2:end)).*diff(ttest))/2;
  end

  for ii=1:length(lmds)
    lmd=lmds(ii);
    w_reg=(X'*X/n+lmd*eye(d+1))\X'*Y/n;
    res=(T(Itest,1:p+1)*w_reg-ftrue(ttest)).^2;
    err_reg(kk,ii)=sum((res(1:end-1)+res(2:end)).*diff(ttest))/2;
  end
end

score=sum(abs(bsxfun(@minus, mean(err_poly), err_poly)),2)+ ...
      sum(abs(bsxfun(@minus, mean(err_reg), err_reg)),2);
[mm,ix]=min(score);

% replay
% noise=[0.7081    0.2523    1.3569    0.1903    0.4282   -1.2192   -0.1973    0.4581    1.2261   -0.6042]';
%
clear w_poly w_reg
Y=ftrue(Xogn)+noise(:,ix);

X=bsxfun(@power, Xogn, 0:d);

w=X\Y;

for ii=1:length(ps)
  p=ps(ii);
  w_poly{ii}=X(:,1:p+1)\Y;
end

for ii=1:length(lmds)
  lmd=lmds(ii);
  w_reg{ii}=(X'*X/n+lmd*eye(d+1))\X'*Y/n;
end

figure, 
subplot(2,2,1);
h=plot(tt, ftrue(tt), '--',...
       tt, T*w, 'b-', ...
       tt, T(:,1:5)*w_poly{4}, 'g-',...
       tt, T(:,1:3)*w_poly{2}, 'c-', ...
       (1:n)/n, Y, 'mx',...
             'markersize', 12, 'linewidth', 2);
set(h(1),'color',[0.5 0.5 0.5]);
set(h(3),'color',[0 0.5 0]);
grid on;
xlim([0 n+1]/n);
ylim([-10 10]);
set(gca,'fontsize',14);
legend('Truth','Poly10',sprintf('Poly%d',ps(4)),sprintf('Poly%d',ps(2)));

subplot(2,2,3);
plot(ps, mean(err_poly), 'linewidth', 2);
ylim([0 4]);
grid on;
set(gca,'fontsize',16);
xlabel('Polynomial order');
ylabel('Expected error');
subplot(2,2,2);
h=plot(tt, ftrue(tt), '--',...
       tt, T*w, 'b-', ...
       tt, T*w_reg{4}, 'g-',...
       tt, T*w_reg{10}, 'c-', ...
       (1:n)/n, Y, 'mx',...
             'markersize', 12, 'linewidth', 2);
set(h(1),'color',[0.5 0.5 0.5]);
set(h(3),'color',[0 0.5 0]);
grid on;
xlim([0 n+1]/n);
ylim([-10 10]);
set(gca,'fontsize',14);
legend('Truth','\lambda=0',sprintf('\\lambda=%g',lmds(4)), sprintf('\\lambda=%g',lmds(10)));


subplot(2,2,4);
semilogx(lmds, mean(err_reg), 'linewidth', 2);
ylim([0 4]);
xlim([1e-8 1e-2]);
set(gca,'xtick',[1e-8 1e-6 1e-4 1e-2]);
set(gca,'xdir','reverse');
grid on;
set(gca,'fontsize',16);
xlabel('Regularization parameter \lambda');
ylabel('Expected error');