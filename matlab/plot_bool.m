clf;
n=5;
X=5*rand(n,1)-2.5; Y=5*rand(n,1)-2.5;

tt=linspace(0,2*pi,100);
for ii=1:n
  x=X(ii)+cos(tt); y=Y(ii)+sin(tt);
  patch([X(ii)*ones(1,length(x)-1); x(1:end-1); x(2:end)],...
        [Y(ii)*ones(1,length(y)-1); y(1:end-1); y(2:end)],...
        [0.5 0.5 1], 'EdgeColor','none');
end
hold on;
for ii=1:n
  x=X(ii)+cos(tt); y=Y(ii)+sin(tt);
  plot(x, y, 'linewidth', 2);
end
hold off;
grid on;
axis equal
axis off;
