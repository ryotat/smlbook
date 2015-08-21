[W1,W2]=ndgrid(-3:0.05:3);

F=0.5*(W1.^2+W2.^2);

a1=1; a2=-2; b=2;

surf(W1, W2, F, 'edgecolor','none','facealpha',0.5);

hold on;
w1=-3:0.1:3; w2=-a1/a2*w1+b/a2;
plot3(w1, w2, 0.5*(w1.^2+w2.^2), 'b-',...
      w1, w2, zeros(length(w1)), 'b--', 'linewidth', 3);

alpha=-2:0.1:2;
w1=-a1*alpha; w2=-a2*alpha;
wstar=[a1, a2]*b/(a1^2+a2^2);
h=plot3(w1, w2, -0.5*(a1^2+a2^2)*alpha.^2-alpha*b, 'c-',...
        wstar(1), wstar(2), 0.5*sum(wstar.^2), 'oc',...
        'markersize', 10,'linewidth', 3);
set(h,'color', [0 .5 0]);

h=quiver3([-3,0,0],[0,-3,0],[0,0,-5],[6,0,0],[0,6,0],[0,0,10],0);
set(h,'color','k');

view([-15 44]);