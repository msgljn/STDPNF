function arrows=DPC(data,Dc,c)
%% DPC
% data
% Dc: cut-off distance
% c: class number
%% calcaulate p and u
n=size(data,1);
[p,dist]=DPC_P(data,Dc);
[u,nneigh,ordP]=DPC_U(p,dist);
%% calculate center
r=p.*u;
[~,index]=sort(r,'descend');
center_idxs=index(1:c);
t=zeros(size(data,1),1);
for i=1:c
    t(center_idxs(i))=i;
end
%% Assignment
%% 1)Assign arrows
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
