function [L,t]=STDPNF(label_x,label_x_t,unlabel_x,Dc)
%% The input paramters of the alogrithm
L=label_x;                 %已标记数据
t=label_x_t;             %已标记数据的类别
U=unlabel_x;               %未标记数据
C=length(unique(t));     %样本的类别总数
%% Use DPC to reveal the data space
data=[L;U];
label=[t;zeros(size(U,1),1)];
arrows=DPC(data,Dc,C);
%% Use the data space to find the sort_idx
sort_idx = Find_index(arrows,L,U );
%% Find NaNs
[NaNE,NaN]=FindNaN(L,U);
%% intialize the variables of the self-training process
count=1; % iteravtive count
L_index=[1:1:size(L,1)]'; % index of L
U_index=[size(L,1)+1:1:size(data,1)];
while 1
    pos=find(sort_idx==count);
    if length(pos)==0
        break;
    end
    index=pos;
    classifyU=data(index,:);
    Pre=KNNC(L,t,classifyU,3);
    previous=L_index;
    %% update L and U
    for i=1:length(index)
        L_index=[L_index;index(i)];
        t=[t;Pre(i)];
        label(index(i))=Pre(i);
    end
    U_index=setdiff([1:1:size(data,1)],L_index);
    L=data(L_index,:);
    U=data(U_index,:);
    %% Use ENaNE to clean data
    [L,t]=ENaNE(NaN,data,label,sort_idx,index,previous,NaNE);
    %%
    count=count+1;
end
end