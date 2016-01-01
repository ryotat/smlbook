datadir='hall/';
files=dir([datadir, '*.bmp']);

ind_tr=round(linspace(1,length(files),200));
files=files(ind_tr);

Y=zeros(25344, length(files));
for ii=1:length(files)
  B=mean(imread([datadir, files(ii).name]),3);
  Y(:,ii)=B(:);
end

sz=size(B);
ind_show=round(linspace(1,size(Y,2),8));

[S,L,A,fval,res, err]=rpca_admm(Y, 1e-6, sqrt(max(size(Y))), ind_show, sz);


for ii=1:4
  kk=ii*2-1;
  subplotxl(3,4, ii, [0 0.1 0], [0 0.1 0.2]);
  imagesc(reshape(Y(:,ind_show(kk)),sz)); colormap gray;
  title(sprintf('frame %d', ind_tr(ind_show(kk))));
  axis off;

  subplotxl(3,4, ii+4, [0 0.1 0], [0 0.1 0.2]);
  imagesc(reshape(L(:,ind_show(kk)),sz)); colormap gray;
  axis off;
  
  subplotxl(3,4, ii+8, [0 0.1 0], [0 0.1 0.2]);
  imagesc(reshape(S(:,ind_show(kk)),sz)); colormap gray;
  axis off;
end
