tt=linspace(0, 2*pi, 100);

x1=-2+2*cos(tt); y1=4*sin(tt);
patch([-2*ones(1,99); x1(1:end-1); x1(2:end)],...
      [zeros(1,99); y1(1:end-1); y1(2:end)], [0.7 0.7 1], 'EdgeColor','none');

x2=2.5+1.2*cos(tt); y2=2.5*sin(tt);
patch([2.5*ones(1,99); x2(1:end-1); x2(2:end)],...
      [zeros(1,99); y2(1:end-1); y2(2:end)], [0.7 0.7 1], 'EdgeColor','none');
hold on;                    
plot(x1, y1, 'b', ...
     -2+0.8*cos(tt), 1.7*sin(tt), 'b--', ...
     x2, y2, 'b', 'linewidth', 2);

text(-2, 4.4, 'R^d', 'fontsize', 24);
text(2.5, 2.9, 'R^n', 'fontsize', 24);

h=annotation('doublearrow');
set_annotation_position(h, [-2 1.2, 4.5, 0]);

h=annotation('doublearrow');
set_annotation_position(h, [-1.7 0.5, 4.5, 0]);

h=annotation('doublearrow');
set_annotation_position(h, [-1.7 -0.5, 4.5, 0]);

h=annotation('doublearrow');
set_annotation_position(h, [-2 -1.2, 4.5, 0]);

axis off;