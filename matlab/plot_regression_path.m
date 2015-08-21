w0=[2; 1];

n=10;
sigma=1;
nrep=1;

lambda=exp(linspace(log(1e-6),log(1e+6),50));

for kk=1:nrep
X=randn(n,2);
yy=X*w0+sigma*randn(n,1);
W=zeros(length(lambda),2);
for ii=1:length(lambda)
  lmd=lambda(ii);
  ww=(X'*X+lmd*eye(2))\(X'*yy);
  W(ii,:)=ww';
  Err(kk,ii)=norm(w0-ww);
end
[W1,W2]=meshgrid(0:0.1:3);
E=zeros(size(W1));
E(:)=sum((yy(:,ones(1,prod(size(E))))-X*[W1(:)'; W2(:)']).^2);

contour(W1, W2, E)
hold on;
tt=0:0.1:2*pi;
plot(cos(tt), sin(tt), 'b--', ...
     2*cos(tt), 2*sin(tt), 'b-', ...
     W(:,1), W(:,2), 'mx-', 'linewidth', 2);
hold off;
drawnow;
end

load 'result_regression_path.mat'

figure;
subplot(1,2,1);
contour(W1, W2, S1.E)
hold on;
tt=0:0.1:2*pi;
plot(cos(tt), sin(tt), 'b--', ...
     2*cos(tt), 2*sin(tt), 'b-', ...
     S1.W(:,1), S1.W(:,2), 'mx-',...
     S2.W(:,1), S2.W(:,2), 'cx:', 'linewidth', 2);
plot(w0(1), w0(2), 'kx', 'MarkerSize', 10, 'linewidth', 2);
hold off;
axis equal; xlim([0 3]); ylim([0 3])
set(gca,'fontsize',14);
xlabel('w1');
ylabel('w2');
text(S1.W(1,1), S1.W(1,2)+0.1, '\lambda=0', 'fontsize', 14);
text(S1.W(end,1), S1.W(end,2)+0.1, '\lambda=inf', 'fontsize', 14);

subplot(1,2,2);
contour(W1, W2, S2.E)
hold on;
tt=0:0.1:2*pi;
plot(cos(tt), sin(tt), 'b--', ...
     2*cos(tt), 2*sin(tt), 'b-', ...
     S1.W(:,1), S1.W(:,2), 'mx:', ...
     S2.W(:,1), S2.W(:,2), 'cx-', 'linewidth', 2);
plot(w0(1), w0(2), 'kx', 'MarkerSize', 10, 'linewidth', 2);
hold off;
axis equal; xlim([0 3]); ylim([0 3])
set(gca,'fontsize',14);
xlabel('w1');
ylabel('w2');
text(S2.W(1,1), S2.W(1,2)+0.1, '\lambda=0', 'fontsize', 14);
text(S2.W(end,1), S2.W(end,2)+0.1, '\lambda=inf', 'fontsize', 14);
