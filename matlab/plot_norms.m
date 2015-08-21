subplotxl(1,3,1,[0 0.05 0], [0 0 0])
plot([-1 0 1 0 -1], [0 -1 0 1 0], 'b',...
     [-2 0 2 0 -2], [0 -2 0 2 0], 'b',...
     'linewidth', 2);
xyaxis([-3 3],[-3 3]);
axis off;

subplotxl(1,3,2,[0 0.05 0], [0 0 0])
tt=linspace(0, 2*pi, 100);
plot(cos(tt), sin(tt), 'b',...
     2*cos(tt), 2*sin(tt), 'b',...
     'linewidth', 2);
xyaxis([-3 3],[-3 3]);
axis off;

subplotxl(1,3,3,[0 0.05 0], [0 0 0])
plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'b',...
     [-2 2 2 -2 -2], [-2 -2 2 2 -2], 'b',...
     'linewidth', 2);
xyaxis([-3 3],[-3 3]);
axis off;
