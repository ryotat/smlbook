function y=meancell(x)

[R,C]=size(x);
y=cell(1,C);

for ii=1:C
  y{ii}=nanmean(cell2mat(x(:,ii)),1);
end
