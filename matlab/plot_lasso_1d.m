floss=@(x)0.5*(x-2).^2+1;
gloss=@(x)x-2;
xx=[-5:0.1:0, 0:0.1:5]; len=length(xx)/2;
signx=[-ones(1,len), ones(1,len)];

subplotxl(1,3,1,[0 0.01 0], [0.1 0 0])
xyaxis([-4 4],[-4 4]);
h=plot(xx, floss(xx), ...
       xx, gloss(xx), ...
       2, 0, 'o', 'MarkerSize', 10, 'linewidth', 2);
set(h(2:3),'color',[.8 0 0])
ylim([-4 4]);
axis off;
text(-0.4, -4.5, '(a)', 'FontSize', 20);

subplotxl(1,3,2,[0 0.01 0], [0.1 0 0])
lmd=1.2;
xyaxis([-4 4],[-4 4]);
h=plot(xx, floss(xx), ...
       xx, lmd*abs(xx), ...
       xx, gloss(xx), '--', ...
       xx, gloss(xx)+lmd*signx, ...
       2-lmd, 0, 'o', 'MarkerSize', 10, 'linewidth', 2);
set(h(3:5),'color',[.8 0 0])
ylim([-4 4]); xlim([-4 6]);
axis off;
h1=annotation('doublearrow')
set_annotation_position(h1, [-0.1 -2, 0, lmd])
h2=annotation('doublearrow')
set_annotation_position(h2, [-0.1 -2, 0, -lmd])
text(-0.6, -1.2, '\lambda', 'FontSize', 20);
text(-0.6, -2.8, '\lambda', 'FontSize', 20);
text(-0.4, -4.5, '(b)', 'FontSize', 20);

subplotxl(1,3,3,[0 0.01 0], [0.1 0 0])
lmd=2.5;
xyaxis([-4 4],[-4 4]);
h=plot(xx, floss(xx), ...
       xx, lmd*abs(xx), ...
       xx, gloss(xx), '--', ...
       xx, gloss(xx)+lmd*signx, ...
       0, 0, 'o', 'MarkerSize', 10, 'linewidth', 2);
set(h(3:5),'color',[.8 0 0])
ylim([-4 4]); xlim([-4 6]);
axis off;
h1=annotation('doublearrow')
set_annotation_position(h1, [-0.1 -2, 0, lmd])
h2=annotation('doublearrow')
set_annotation_position(h2, [-0.1 -2, 0, -lmd])
text(-0.6, -1, '\lambda', 'FontSize', 20);
text(-0.6, -3, '\lambda', 'FontSize', 20);
text(-0.4, -4.5, '(c)', 'FontSize', 20);
