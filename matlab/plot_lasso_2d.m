A=[1 0.5; 0 1]; bb=A*[1.5;0.5]; lmd=0.5;

lmds=[0.2 0.5 1];

for ii=1:length(lmds)
  lmd=lmds(ii);
  subplotxl(1,3,ii,[0 0.1 0], [0 0 0.1])
  xx=plotcontours([-2 2], [-2 2], A, bb, lmd);
  C=full(sum(abs(xx)));
  grid on;
  xyaxis([-2 2],[-2 2]);
  title(sprintf('\\lambda=%g (C=%.2f)', lmd, C),'FontSize',16);
  axis off
end

