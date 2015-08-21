function out=kmax(X,k)

sz=size(X);
Y=sort(X,1,'descend');
out=reshape(Y(k,:),[1,sz(2:end)]);