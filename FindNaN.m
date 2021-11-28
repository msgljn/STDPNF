function  [NaNE,NaN]=FindNaN(L,U)
%% search for NaN and return NaNE
data=[L;U];
n=size(data,1);
%% initialize  variables
NaN=cell(n,1)';
RN=zeros(n,1);
KNN=cell(n,1)';
RNN=cell(n,1)';
%% create k-d tree
kdtree=KDTreeSearcher(data,'bucketsize',1); 
index = knnsearch(kdtree,data,'k',n);
index(:,1)=[];
%% initialize iterative variables
r=1;
tag=1;
while tag
    KNN_idx=index(:,r);
    %% comput KNN and RNN
    for i=1:n
        RNN{KNN_idx(i)}=[RNN{KNN_idx(i)};i];
        KNN{i}=[KNN{i};KNN_idx(i)];
    end
    %% find samples that have no RNN 
    pos=[];
    for i=1:n
        if ~isempty(RNN{i})  
           pos=[pos;i];
        end
    end
    RN(pos)=1;
    %% stopping condition
    cnt(r)=length(find(RN==0));
    if r>2 && cnt(r)==cnt(r-1)
       tag=0;
       r=r-1;
    end
    r=r+1;
end
for i=1:n
    NaN{i}=intersect(RNN{i},KNN{i});
end
NaNE=r;
end