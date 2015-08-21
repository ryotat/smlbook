%%
tt=-3:0.1:3;

func1 = max(abs(tt)-1,0).^2;
func2 = max(abs(tt)-1,0) + 0.5*(min(abs(tt),1)).^2;

st    = max(abs(tt)-1,0).*sign(tt);
ht    = min(abs(tt),1).*sign(tt);

% ax(1,1)=axes('position', [0.1300    0.55    0.3347    0.43]);
subplot(1,2,1);
h=plot(tt, func2,tt, abs(tt),'m--', 'linewidth', 2);
grid on;
set(gca,'fontsize',16,'xtick',-1:1);
format_ticks(gca, {'-\lambda', '0', '\lambda'});
set(gca,'xtick',-3:3,'yticklabel',[]);
xlim([-3 3]);
legend(flipud(h),'\lambda |x|','Env[\lambda | |](x)',...
       'Location','NorthOutside',...
       'Orientation','horizontal');




% ax(1,2)=axes('position',[0.5703    0.55    0.3347    0.43]);
subplot(1,2,2);
h(2)=plot(tt, func1, 'linewidth', 2);
hold on;
yl=ylim;
h(1)=plot([-1;-1;1;1],yl([2,1,1,2]),'m--','linewidth',2);
grid on;
set(gca,'fontsize',16,'xtick',-1:1);
format_ticks(gca, {'-\lambda', '0', '\lambda'});
set(gca,'xtick',-3:3,'yticklabel',[]);
xlim([-3 3]);
legend(h,'\delta_{\lambda}(x)','Env[\delta_{\lambda}](x)',...
       'Location','NorthOutside',...
       'Orientation','horizontal');
