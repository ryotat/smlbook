figure;
A=eye(2); bb=A*[1.5;0.5]; lmd=0.5; step=0.5;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[X,X1,fval]=ist([-1;1],A,bb,lmd,200,step);
plot(X(1,:), X(2,:), '-o', 'linewidth',2)
h=quiver(X(1,:), X(2,:), X1(1,:)-X(1,:), X1(2,:)-X(2,:), 0);
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off
printFigure(gcf,'stpath0.eps');

figure;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[xx,stat]=dalsql1([-1;1],A,bb,lmd,'solver','nt','iter',1,'eta',1);
plot(xx(1,:), xx(2,:), '-o', 'linewidth',2)
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off;
printFigure(gcf,'dalpath0.eps');

figure;
A=[1 1; 0 1]; bb=A*[1.5;0.5]; lmd=0.5; step=0.5;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[X,X1,fval]=ist([-1;1],A,bb,lmd,200,step);
plot(X(1,:), X(2,:), '-o', 'linewidth',2)
h=quiver(X(1,:), X(2,:), X1(1,:)-X(1,:), X1(2,:)-X(2,:), 0);
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off
printFigure(gcf,'stpath1.eps');

figure;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[xx,stat]=dalsql1([-1;1],A,bb,lmd,'solver','nt','iter',1,'eta',1);
plot(xx(1,:), xx(2,:), '-o', 'linewidth',2)
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off;
printFigure(gcf,'dalpath1.eps');


figure;
A=[1 2; 0 1]; bb=A*[1.5;0.5]; lmd=0.5; step=0.3;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[X,X1,fval]=ist([-1;1],A,bb,lmd,200,step);
plot(X(1,:), X(2,:), '-o', 'linewidth',2)
h=quiver(X(1,:), X(2,:), X1(1,:)-X(1,:), X1(2,:)-X(2,:), 0);
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off
printFigure(gcf,'stpath2_step=0.3.eps');


figure;
plotcontours([-2 2], [-2 2], A, bb, lmd);
[xx,stat]=dalsql1([-1;1],A,bb,lmd,'solver','nt','iter',1,'eta',1);
plot(xx(1,:), xx(2,:), '-o', 'linewidth',2)
set(h,'linewidth',2)
xyaxis([-2 2],[-2 2]);
axis off;
printFigure(gcf,'dalpath2.eps');
