function set_annotation_position(h, pos)

apos=get(gca,'position');
xl=xlim; xw=xl(2)-xl(1); xo = xl(1);
yl=ylim; yw=yl(2)-yl(1); yo = yl(1);

gpos=[(pos(1)-xo)*apos(3)/xw+apos(1),...
      (pos(2)-yo)*apos(4)/yw+apos(2),...
      pos(3)*apos(3)/xw,...
      pos(4)*apos(4)/yw];

set(h, 'Position', gpos);
