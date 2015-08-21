subplotxl(1,3,1);
patch([-1.5 1 -1.5],[2.5 0 -2.5],[0.8 0.8 1],'edgecolor','none');
xyaxis([-2 2],[-2 2]);
plot([0 1 0 -1 0],[-1 0 1 0 -1],'-',...
     [-1 2],[2.5,-1.25],'m-',...
     1, 0, 'ko', 'linewidth',2); 
text(1.1,0.2,'w*','fontsize',16);
text(-0.3,-2,'(a)','fontsize', 32);
axis off;
xlim([-2.5 2.6]); ylim([-2.5 2.5]);

subplotxl(1,3,2);
patch([-1.5 1 -1.5],[2.5 0 -2.5],[0.8 0.8 1],'edgecolor','none');
xyaxis([-2 2],[-2 2]);
plot([0 1 0 -1 0],[-1 0 1 0 -1],'-',...
     0.8*[0 1 0 -1 0],0.8*[-1 0 1 0 -1],'b:',...
     [-1.5 2],[2,-0.8],'m-',...
     1, 0, 'ko', 'linewidth',2); 
text(1.1,0.2,'w*','fontsize',16);
text(-0.3,-2,'(b)','fontsize', 32);
axis off;
xlim([-2.5 2.5]); ylim([-2.5 2.5]);

subplotxl(1,3,3);
patch([-0.75 1.75 0 -2.5],[1.75 -0.75 -2.5 0],[0.8 0.8 1],'edgecolor','none');
xyaxis([-2 2],[-2 2]);
plot([0 1 0 -1 0],[-1 0 1 0 -1],'-',...
     [-1.1 1.9],[2.5,-1.25],'m-',...
     0.5, 0.5, 'ko', 'linewidth',2); 
text(0.6,0.7,'w*','fontsize',16);
xlim([-2.5 2.5]); ylim([-2.5 2.5]);
text(-0.3,-2,'(c)','fontsize', 32);
axis off;
set(gcf,'position',[50   501   879   297]);
