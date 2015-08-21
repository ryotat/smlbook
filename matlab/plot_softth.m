xyaxis([-3 3],[-3 3]);
h=plot([-3,-1,1,3],[-2,0,0,2],'b-',...
     [-3 3], [-3/2, 3/2], 'm-', 'linewidth',2);

text(-1,-0.2,'\lambda','fontsize',24);
text(1,-0.2,'\lambda','fontsize',24);
set(gca,'fontsize',24);
legend(h,'prox for L_1', 'prox for L_2^2');

axis off;