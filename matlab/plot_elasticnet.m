theta=0.7;
C=1+theta/2;
xx=-1:0.01:1;
yy=(sqrt(1+2*theta*C-theta*(theta*xx.^2+2*abs(xx)))-1)/theta;

h=plot([-1 0 1 0 -1], [0 -1 0 1 0], 'm--',...
     [xx, fliplr(xx)], [yy, -fliplr(yy)], 'b-', 'linewidth', 2);

axis equal;

xyaxis([-1.2 1.2],[-1.2 1.2]);

h=legend(h,'L_1','ElasticNet','orientation','horizontal');
set(h,'FontSize',16);
axis off;