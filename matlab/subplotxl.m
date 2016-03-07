function ax=subplotxl(mm,nn,pp,mh,mv)

opt=struct('amh', [0 0 0], 'amv', [0 0 0]);

if ~exist('mh','var') || isempty(mh)
  mh=[0 0 0];
end

if ~exist('mv','var') || isempty(mv)
  mv=[0 0 0];
end

if length(mh)==1, mh = mh*[1 1 1]; end
if length(mv)==1, mv = mv*[1 1 1]; end

if length(pp)==1
  pp = [ceil(pp/nn), mod1(pp, nn)];
end


mh = mh/nn+opt.amh;
mv = mv/mm+opt.amv;
width  = (1-mh(1)-mh(3)-mh(2)*(nn-1))/nn;
height = (1-mv(1)-mv(3)-mv(2)*(mm-1))/mm;
left   = mh(1);
bottom = mv(1);

ax=axes('position',[left+(width+mh(2))*(pp(2)-1),...
                    bottom+(height+mv(2))*(mm-pp(1)),...
                    width, height]);

