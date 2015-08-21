function xx=plotcontours(xl, yl, A, bb, lambda)

xx=dalsql1([0;0],A,bb,lambda,'display',0,'tol',1e-4,'solver','nt');

C=sum(abs(xx));

X=linspace(xl(1), xl(2), 100);
Y=linspace(yl(1), yl(2), 100);

[X,Y]=meshgrid(X, Y);

Xv=[X(:), Y(:)];

R=bsxfun(@minus, A*Xv', bb);
F=zeros(size(X));
F(:)= 0.5*sum(R.^2)'; % +lambda*sum(abs(Xv),2);

Uv=A'*R; % +lambda*sign(Xv');
U=zeros(size(X)); U(:)=Uv(1,:);
V=zeros(size(X)); V(:)=Uv(2,:);

Fxx=0.5*sum((A*xx-bb).^2);

contour(X, Y, F, Fxx*[0.2, 0.5, 1], 'linewidth', 2);
hold on;
% quiver(X,Y,-U,-V);
grid on;
daspect([1 1 1]);

plot(C*[-1 0 1 0 -1],C*[0 1 0 -1 0],'m--','linewidth',2);
plot(xx(1), xx(2), 'ro', 'linewidth',2, 'markersize', 10);
