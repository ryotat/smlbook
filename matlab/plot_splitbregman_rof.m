%              rof_mex_demo.m  by Tom Goldstein
% This code tests the method defined by "splitBregmanROF.c".  This code
% must be compiled using the "mex" command before this demo will work.

addpath /Users/ryotat/Migration/reykjavik/splitBregmanROF_mex
 
% Step 1:  Get the test image
exact = double(imread('~/Downloads/standard_test_images/cameraman.tif'));

n=size(exact,1);

noisy = exact+50*randn(n,n);

% Step 2: Denoise the Image

clean = splitBregmanROF(noisy,.02,0.001);

% Step 3:  Display Results

close all;
figure;
subplot(1,3,1);
imagesc(exact);
colormap(gray);
title('Original');
axis image

subplot(1,3,2);
imagesc(noisy);
colormap(gray);
title('Noisy');
axis image

subplot(1,3,3);
imagesc(clean);
colormap(gray);
title('Denoised');
axis image


% Gradient
[Gx,Gy]=gradient(exact);
[Nx,Ny]=gradient(randn(n,n));
Gn=sqrt(Gx.^2+Gy.^2); Gn=Gn/mean(Gn(:));
Nn=sqrt(Nx.^2+Ny.^2); Nn=Nn/mean(Nn(:));
loglog(1:n^2,sort(Gn(:),'descend'),...
       1:n^2,sort(Nn(:),'descend'),'linewidth',2);
set(gca,'fontsize',16);
grid on;
xlabel('Rank');
ylabel('Magnitude');
legend('Cameraman','Noise');