tt=linspace(0, 2*pi, 100);
patch([-2 0 2 -2], [0 0 0 0], [4 0 4 4], [0.7 0.7 1],...
      'FaceAlpha', 0.3, 'EdgeColor', 'none');
hold on;
plot3([-2 0 2],[0 0 0],[4 0 4], 'b-',...
      cos(tt), sin(tt), 2*ones(size(tt)),'b--',...
      0.5, 0, 2, 'mo', ...
      [0 1], [0 0], [0 4], 'm-', 'linewidth', 2, 'markersize', 10);
view([0 10]);

axis off;