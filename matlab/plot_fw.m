C=1;
A=randn(10,3);
w0=[1,1,0]';
yy=A*w0+randn(10,1);

[W,I,fval]=fwl1(A,yy,C);

figure;
[X,Y]=meshgrid(0:0.01:C);
Z=zeros(size(X));
Z(:)=0.5*sum(bsxfun(@minus, ...
                    [X(:), Y(:), zeros(prod(size(X)),1)]*A',yy').^2,2);
contourf(X,Y,Z);
%h=line([0 0 1 1], [0 1 1 0]); set(h,'linestyle','--','color','k');
h=patch(C*[1 0 0],C*[0 1 0],C*[0 0 1], [0.5 0.5 1],'FaceAlpha',0.3);
hold on;
plot3(W(1,:), W(2,:), W(3,:),'-x','linewidth',3)
set(gca,'box','off');
grid on;