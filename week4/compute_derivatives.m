Txx = (T(iny,east)-2*T(iny,inx)+T(iny,west))/(dx^2);
Tyy = (T(north,inx)-2*T(iny,inx)+T(south,inx))/(dy^2); 
Tx = (T(iny,east)-T(iny,west))/(2*dx);
Ty = (T(north,inx) - T(south,inx))/(2*dy); 