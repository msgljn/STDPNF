function  [NaN,r]=NaN_Search(L,U)
%%
% function: NaN_Search
% input: L:labeled data;  U:unlabeled data
% output: NaN: natural neighbors; r:  natural neighbor eigenvalue
%%
data=[L;U];
%% Search RNN  By  NaN_search
%% initialize paramters
n=size(data,1);
r=1;
tag=1;
NaN=cell(n,1)';
RN=zeros(n,1);
%%
Dist=pdist2(data,data);
index=cell(n,1);
for i=1:n
    [~,index{i}]=sort(Dist(i,:),'ascend');
end
%%
count=1;
while tag

    KNN_idx=[];
    for i=1:n
        tempidx=index{i};
        KNN_idx=[KNN_idx;tempidx(r+1)];
    end

    for i=1:n
        NaN{KNN_idx(i)}=[NaN{KNN_idx(i)},i];
    end

    pos=[];
    for i=1:n
        if length(NaN{i})~=0 
           pos=[pos;i];
        end
    end
    RN(pos)=1;

    cnt(r)=length(find(RN==0));
    if r>1 && cnt(r)==cnt(r-1)
        tag=0;
        r=r-1;
    end
    r=r+1;
    count=count+1;
end
for i=1:n
    NaN{i}=unique(NaN{i});
end
end