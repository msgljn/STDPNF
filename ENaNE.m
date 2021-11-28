function [L,t]=ENaNE(NaN,data,label,sort_idx,new_index,previous,NaNE)
%% 
%  NaN: natural neighbors
%  data: SSL data
%  label: labels of each sample in SSL data
%  sort_idx: labeled index reveled by DPC
%  new_index: the index of newly labeled sampls
%  previous: the index of labeled samples
%  NaNE: r computed by NaN_search(findNaN)
%%
% (1) 记录新标记的无标记样本的序号，大小，数据，类标签
pos=new_index;
n=length(pos);
new_data=data(pos,:);
new_t=label(pos);
% (2)记录新被标记的无标记样本的自然近邻
unlabel_NaN=[]; % 记录的无标记的自然近邻
for i=1:n
    v=pos(i); 
    if length(NaN{v})~=0
        for j=1:length(NaN{v})
            if label(NaN{v}(j))==0    % 如果该自然近邻是没有标记的，则记录
                unlabel_NaN=[unlabel_NaN;NaN{v}(j)];
            end
        end
    end
end
%% Use a self-training method to predict the label class of unlabeled NaNs
classifyU=data(unlabel_NaN,:);
pos1=find(label~=0);
L=data(pos1,:);
t=label(pos1,:);
Pre=Self_Training(L,t,classifyU,sort_idx(unlabel_NaN),NaNE);
label(unlabel_NaN)=Pre;
%% 记录每个新预测的无标记样本的自然近邻的类标签
LB=cell(n,1);
for i=1:n
    v=pos(i);
    if ~isempty(NaN{v})
        for j=1:length(NaN{v})
            LB{i}(j)=label(NaN{v}(j));
        end
    end
end
%% 
RLB=zeros(n,1);
for i=1:n
    if ~isempty(LB{i})
         RLB(i)=mode(LB{i});
    else
        RLB(i)=99;
    end
end
%% find noise
NoiseIndex=find((new_t-RLB)~=0);
filterIndex=find((new_t-RLB)==0);
%% assign index
TrainingSet=new_data;
TrainingSet_Label=new_t;
L=TrainingSet(filterIndex,:);
t=TrainingSet_Label(filterIndex,:);
%% update L
L=[data(previous,:);L];
t=[label(previous);t];
end

