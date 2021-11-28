function [arrows,t,center_idxs]=DPC(data,k,c)
%% running the alogrithm
n=size(data,1);
[p,dist]=DPC_P(data,k);
[u,nneigh,ordP]=DPC_U(data,p,dist);
%% plot decision figure
r=p.*u;
[value,index]=sort(r,'descend');
center_idxs=index(1:c);
t=zeros(size(data,1),1);
for i=1:c
    t(center_idxs(i))=i;
end
%% Assignment
arrows=zeros(n,1);
for i=1:length(t)
    if (t(ordP(i))==0)
        if nneigh(ordP(i))~=0
            t(ordP(i)) = t(nneigh(ordP(i)));
            arrows(ordP(i))=nneigh(ordP(i));
        end
    end
end
end
