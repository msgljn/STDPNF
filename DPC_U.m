function [u,nneigh,ordP]=DPC_U(data,p,dist)
%%
u = zeros(size(p));
nneigh= zeros(size(p));
[valueP,ordP]=sort(p,'descend');
u(ordP(1)) = -1; 
for i = 2:size(dist,1)
    range = ordP(1:i-1);
    [u(ordP(i)), tmp_idx] = min(  dist(ordP(i),range)  ); 
     nneigh(ordP(i)) = range(tmp_idx);  
end
u(ordP(1)) = max(dist(ordP(1),:));
end