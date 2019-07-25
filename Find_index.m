function sort_idx = Find_index( arrows,L,U )
%% initialize
data=[L;U];
n=size(data,1);
L_index=[1:1:size(L,1)]';
U_index=[size(L,1)+1:1:n];
%% 返回值
sort_idx=zeros(n,1);
count=1;
%% 得到sort_idx
while 1
    %fprintf('-----------------------------------%g--------------------------------------\n',count)
    index=intersect(arrows(L_index)',U_index);
    if length(index)==0
        break;
    end
    sort_idx(index)=count;
    U_index=setdiff(U_index,index);
    L_index=[L_index;index'];
    count=count+1;
end
%% step 3
while 1
    index=[];
    for i=1:length(L_index)
        pos=find(arrows(U_index)==L_index(i));
        index=[index;U_index(pos)'];
    end
    sort_idx(index)=count;
    if length(index)==0
        break;
    end
     U_index=setdiff(U_index,index);
     for i=1:length(index)
         L_index=[L_index;index(i)];
     end 
    count=count+1;
end
end

