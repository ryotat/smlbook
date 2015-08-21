function W=continuation(func, w0, params)

d=length(w0);
W=zeros(d,length(params));
for kk=1:length(params)
  W(:,kk)=func(w0,params(kk));
  w0=W(:,kk);
end
