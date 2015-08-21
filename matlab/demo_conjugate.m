% demo_conjugate - interactively plots the convex conjugate of arbitrary functions
%
% Syntax:
%  demo_conjugate(funcp, xx, gg)
%     funcp: function handle to the function you want to plot
%        xx: x values for the function
%        gg: x-range of the convex conjugate function (optional)
% Examples:
% demo_conjugate(@(x)abs(x),-5:0.1:5)
% demo_conjugate(@(x)x.*log(x)+(1-x).*log(1-x),0.001:0.001:0.999)
%
% Copyright: Ryota Tomioka, 2012
%
function demo_conjugate(funcp, funcd, xx, gg)

ax(1)=subplot(1,2,1);
ff=funcp(xx);
yl=[min(ff), max(ff)]+[-1 1]*0.2*(max(ff)-min(ff));
h=plot(xx, ff, 'linewidth',2);
ylim(yl);
set(gca,'fontsize',16);
title('Primal');
grid on;

ax(2)=subplot(1,2,2);
if ~exist('gg','var')
  gg=diff(ff)./diff(xx);
  mg=min(gg);  Mg=max(gg);
  gg=linspace(mg-0.2*(Mg-mg), Mg+0.2*(Mg-mg), 1000);
end
plot(gg, funcd(gg), 'color',[0 .5 0],'linewidth',2);
xlim([min(gg), max(gg)]);
set(gca,'fontsize',16);
title('Dual');
grid on;

set(ax(1),'ButtonDownFcn',{@cbClickPrimal, funcp, xx, ax});
set(gcf,'WindowButtonMotionFcn',{@cbMotion, funcp, xx, gg, ax});

function cbMotion(src, eventdata,funcp,xx,yy,ax)
cbFunc=get(src,'WindowButtonMotionFcn');
set(src,'WindowButtonMotionFcn','')
cp=get(ax(1),'CurrentPoint');
x0=cp(1);
if x0>=min(xx) && x0<max(xx)
  f0=funcp(x0);

  axes(ax(1));
  h=findobj('color','m','marker','o');
  delete(h);
  h=line(x0,f0);
  set(h,'color','m','marker','o','linewidth',2);

  axes(ax(2));
  xl=get(gca,'xlim');
  h=findobj('color',[0 .5 0],'linestyle','-');
  if ~isempty(h)
    ydata=max(get(h,'YData'), yy*x0-f0);
    set(h,'ydata',ydata);
  else
    h=line(yy, yy*x0-f0);
    set(h,'color',[0 .5 0],'linewidth',2);
    ydata=get(h,'YData');
  end
  yl=[min(ydata), max(ydata)]+[-1 1]*0.2*(max(ydata)-min(ydata));
  
  h=findobj('color','m','linestyle','--');
  delete(h);
  h=line(xl, xl*x0-f0);
  set(h,'color','m','linestyle','--','linewidth',2);
  ylim(yl);
end

cp=get(ax(2),'CurrentPoint');
y0=cp(1,1);
d0=cp(1,2);

yl=get(ax(2),'xlim');
if y0>=yl(1) && y0<=yl(2)
  axes(ax(1));
  xl=get(gca,'xlim');
  h=findobj('color','c','linestyle','--');
  delete(h);
  h=line(xl, xl*y0-d0);
  set(h,'color','c','linestyle','--','linewidth',2);  

  axes(ax(2));
  h=findobj('color','c','marker','o');
  delete(h);
  h=line(y0, d0);
  set(h,'color','c','marker','o','linewidth',2);
else
  h=findobj('color','c','linestyle','--');
  delete(h);
  h=findobj('color','c','marker','o');
  delete(h);
end


set(src,'WindowButtonMotionFcn',cbFunc)


function cbClickPrimal(src, eventdata,funcp,xx,ax)
cp=get(ax(1),'CurrentPoint');
x0=cp(1);
if x0>=min(xx) && x0<max(xx)
  col=colormap;
  kk=mod1(15*length(get(ax(1),'children')), size(col,1));
  col=col(kk,:);
  
  f0=funcp(x0);

  axes(ax(1));
  h=line(x0,f0);
  set(h,'color',col,'marker','o','linewidth',2);

  axes(ax(2));
  xl=get(gca,'xlim');
  h=line(xl, xl*x0-f0);
  set(h,'color',col,'linestyle','--','linewidth',2);
end

function m=mod1(n,k)
m=mod(n-1,k)+1;