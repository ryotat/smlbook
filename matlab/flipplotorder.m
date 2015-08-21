function flipplotorder(ax)

if ~exist('ax','var');
  ax=gca;
end

h=get(ax,'children');
set(ax,'children',flipud(h));