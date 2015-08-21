C=linspace(0,20,100);
tt=[0:max(C)];
P=75;
t=47; % 42.68; % 48.47;
lmd=3;
c=5.6;

f=@(x)max(20,20+55*exp(-0.3*x));

patch([0,C,max(C)],[80,f(C),80],[0.8, 0.8 1],'edgecolor','none');
hold on;
h=plot([0 max(C)], [20, 20], ':',...
       [0 c c], [t-lmd*c, t-lmd*c, 0], ':',...%       tt, P-2*55*tt, '--',...
       C, f(C), ...
       [0 0], [P, P+5],...
       tt, 55-lmd*tt, '--',...
       tt, t-lmd*tt, ...
       c, t-lmd*c, 'ok', 'linewidth', 2);

set(h(1:2),'color',[.5 .5 .5]);
%set(h(3),'color', [.4 .8 .4]);
set(h(3:4),'color',[0 0 1]);
set(h(5),'color',[0 .5 0]);
set(h(6),'color',[0 .4 0]);
ylim([0 80]);
grid off;
set(gca,'xtick',[],'ytick',[]);
text(-1,20,'L_0','fontsize',20);
text(-2.2,t-lmd*c,'L(w^)','fontsize',20,'interpreter','none');
text(c-1, -4, 'g(w\^)','fontsize',20);
text(6,58-3*6,'L+{\lambda}C=t','fontsize',20);
text(-1,-1, 'O', 'fontsize', 20);

text(10,-6,'C','fontsize',36);
text(-2,45,'L','fontsize',36);