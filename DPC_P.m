function [p,distance]=DPC_P(data,Dc)
%%
distance=pdist2(data,data);
n=size(data,1);
p=zeros(n,1);
for i=1:n
   p(i)=length(find(distance(i,:)<Dc));
end
end