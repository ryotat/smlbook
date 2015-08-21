subplot(1,2,1);
h=quiver([0 0 0 0],[0 0 0 0],[1,0,-1,0],[0,1,0,-1],0);
set(h,'color',[0 0 1], 'linewidth',2);
patch([-1 0 1 0],[0 -1 0 1],[0.5 0.5 1],'FaceAlpha',0.3,'EdgeColor',[0 0 1]);
text(-0.1, -1.2, '(a)', 'FontSize', 16);

subplot(1,2,2);
X=randn(5,2); X=diag(1./sqrt(sum(X.^2,2)))*X;
h=quiver(zeros(5,1),zeros(5,1),X(:,1),X(:,2),0);
set(h,'color',[0 0 1], 'linewidth', 2);
[~,ind]=sort(X(:,1));
X=X(ind,:);
patch(X(:,1), X(:,2), [0.5 0.5 1],'FaceAlpha',0.3,'EdgeColor',[0 0 1])

set(gcf,'position', [240   432   894   366]);

