function ACC=STDPNF(label_x,label_x_t,unlabel_x,test_x,test_t,Dc)
%%
% function: STDPNF
% [label_x,label_x_t]: labeled data
% unlabel_x: unlabeled data
% [test_x, test_t]: test data
% cut-off: Dc
% return ACC: classification accuracy
%% The input paramters of the alogrithm
L=label_x;                
L_t=label_x_t;             
U=unlabel_x;              
t=L_t;                     
C=length(unique(L_t));     
%% Step One: discover underlying structure by DPC 
% (1) running DPC
data=[L;U];
label=[t;zeros(size(U,1),1)];
arrows=DPC(data,Dc,C);
% (2) reconstrcut the structure discovered by DPC
sort_idx = Find_index(arrows,L,U ); % classification order
count=1;
L_index=[1:1:size(L,1)]';
%% Step two: self-training process
% (1) NaN_Search
[NaN,r]=NaN_Search(L,U);
%(2) self-training process
while 1
    pos=find(sort_idx==count);
    if isempty(pos)
        break;
    end
    % （2）classify
    index=pos;
    classifyU=data(index,:);
    Pre=KNNC(L,t,classifyU,3);
    previous=L_index;
    %% update unlabeled data
    for i=1:length(index)
        L_index=[L_index;index(i)];
        t=[t;Pre(i)];
        label(index(i))=Pre(i);
    end
    U_index=setdiff([1:1:size(data,1)],L_index);
    L=data(L_index,:);
    U=data(U_index,:);

    [L,t]=ENaNE(NaN,r,data,label,sort_idx,index,previous);
    count=count+1;
end
%%
% 计算测试集分类正确率
value=[];index=[];
index=KNNC(L,t,test_x,3);
ACC=sum(test_t==index)/size(test_t,1);
fprintf('---classification accuracy (ACC): %g\n',ACC);
end