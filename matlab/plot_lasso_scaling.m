load ~/Dropbox/20130814dtu/matlab/results/lasso_k=10.mat

figure, imagesc(ps, ns, mean(err,3));
hold on; plot(ps, 20*log(ps), 'm--', 'linewidth', 2);
hold on; plot(ps, 25*log(ps), 'm--', 'linewidth', 2);
hold on; plot(ps, 30*log(ps), 'm--', 'linewidth', 2);

set(gca,'fontsize',14)
colorbar;

xlabel('d');
ylabel('n');

title('Average error ||w^-w*||','interpreter','none');


ix=[1,2,4,8];
figure, 
h=errorbar_logsafe(ns'*(1./log(ps(ix))), mean(err(:,ix,:),3), std(err(:,ix,:),[],3));
set(h,'linewidth',2);
grid on;
set(gca,'fontsize',14);
xlabel('n/log(d)');
ylabel('Error ||w^-w*||','interpreter','none');
legend(cellfun(@(x)sprintf('d=%d',x), num2cell(ps(ix)), ...
               'uniformoutput',0));
set(gcf,'position',[150 367  533   439]);