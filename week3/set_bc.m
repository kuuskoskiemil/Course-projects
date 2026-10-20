T(1,:) = T(2,:); 
T(Nytot,:) = T(Nytot-1,:); 
T(:,1) = T(:,2); 
T(:,Nxtot) = T(:,Nxtot-1); 
