grad=linspace(0,1,64)'; igrad=flipud(grad);
map = [grad, grad, ones(64,1); ones(64,1), igrad, igrad];

X1=zeros(10,15);
X1([2,6,7,10],:)=randn(4,15);

X2=zeros(10,15);
X2(:)=randsparse(10*15, 20);


[U,S,V]=svd(X1+X2);
X=S(1)*U(:,1)*V(:,1)';

subplot(1,3,1);
imagesc(X1);
colormap(map);
set(gca,'clim', [-2 2],...
        'xaxislocation','top',...
        'fontsize',16,...
        'xtick',[],'ytick',[]);
xlabel('Tasks');
ylabel('Variables');

subplot(1,3,2);
imagesc(X);
colormap(map);
set(gca,'clim', [-2 2],...
        'xaxislocation','top',...
        'fontsize',16,...
        'xtick',[],'ytick',[]);
xlabel('Tasks');
ylabel('Variables');


subplot(1,3,3);
imagesc(X1+X2);
colormap(map);
set(gca,'clim', [-2 2],...
        'xaxislocation','top',...
        'fontsize',16,...
        'xtick',[],'ytick',[]);
xlabel('Tasks');
ylabel('Variables');

