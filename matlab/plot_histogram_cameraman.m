I=double(imread('~/cameraman.tif'))/255;
[Dx,Dy]=gradient(I);
G=sqrt(Dx(:).^2+Dy(:).^2);
[Gc, Gx]=hist(G, 50);

N=rand(512,512);
[Dx,Dy]=gradient(N);
Gn=sqrt(Dx(:).^2+Dy(:).^2);
[Gnc, Gnx]=hist(Gn, 50);

figure, plot(Gx, Gc, Gnx, Gnc, 'linewidth', 2);
grid on;
set(gca,'fontsize',16);
xlabel('Norm of gradient');
ylabel('Frequency');
legend('cameraman','noise')