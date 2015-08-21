tt=-3:0.1:3;
yy=[0.5+0.5*(tt(tt<0)+1).^2, exp(tt(tt>=0))];
xyaxis([-3 3],[-2 4]);
plot(tt, yy, tt, 2*tt.^2+tt+1, [-3 3], [-3 3]+1,'m--', 'linewidth', 2)
ylim([-2 4])
hold on;
plot([0 0], [0 1], 'b--', 0, 1, '*', 'linewidth',2);
plot(-[1 1], [0 0.5], 'b--', -1, 0.5, '*','linewidth', 2)
plot(-0.25*[1 1], [0 1-0.25+2*0.25^2], '--', -0.25, 1-0.25+2*0.25^2, ...
     '*','color', [0 .5 0],'linewidth', 2);
text(1.5, 4, 'L(w)', 'FontSize', 24);
text(-0.25, -0.25, 'w^{t}', 'FontSize', 24);
text(-0.8, -0.25, 'w^{t+1}', 'FontSize', 24);
text(-1.3, -0.25, 'w*', 'FontSize', 24);
