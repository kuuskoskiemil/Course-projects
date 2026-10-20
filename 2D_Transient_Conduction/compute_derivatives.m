Txx = (T(iny,east)-2*T(iny,inx)+T(iny,west))/(dx*dx);
Tyy = (T(north,inx)-2*T(iny,inx)+T(south,inx))/(dy*dy); 
Tx = (T(iny,east)-T(iny,west))/(2*dx);
Ty = (T(north,inx) - T(south,inx))/(2*dy); 