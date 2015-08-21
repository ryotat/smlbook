% max((x-y)^2+4*z^2,(x+y)^2)=1

[X,Y,Z]=meshgrid(-2:0.02:2);
F=zeros(size(X));

I=X.*Y-Z.^2>0;
T1=abs(X+Y);
T2=0.5*(abs(X+Y+sqrt((X-Y).^2+4*Z.^2))+abs(X+Y-sqrt((X-Y).^2+4*Z.^2)));
F(I)=T1(I);
F(~I)=T2(~I);

figure, isosurface(X,Y,Z,F,1.0);
