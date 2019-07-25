function [L,t]=ENaNE(NaN,r,data,label,sort_idx,new_index,previous)
%%
% function: ENaNE
%
%%
pos=new_index;
n=length(pos);
new_data=data(pos,:);
new_t=label(pos);

unlabel_NaN=[];
total_NaN=[];
for i=1:n
    v=pos(i); 
    if length(NaN{v})~=0
        for j=1:length(NaN{v})
            if label(NaN{v}(j))==0
                unlabel_NaN=[unlabel_NaN;NaN{v}(j)];
            end
            total_NaN=[total_NaN;NaN{v}(j)];
        end
    end
end
%% 
classifyU=data(unlabel_NaN,:);
pos1=find(label~=0);
L=data(pos1,:);
t=label(pos1,:);
Pre=SelfTraining_idx(L,t,classifyU,sort_idx(unlabel_NaN),r);
label(unlabel_NaN)=Pre;
%% label list
LB=cell(n,1);
for i=1:n
    v=pos(i);
    if length(NaN{v})~=0
        for j=1:length(NaN{v})
            LB{i}(j)=label(NaN{v}(j));
        end
    end
end
%%
RLB=zeros(n,1);
for i=1:n
    if length(LB{i})~=0
         RLB(i)=mode(LB{i});
    else
        RLB(i)=99;
    end
end
%% find noise
NoiseIndex=find((new_t-RLB)~=0);
filterIndex=find((new_t-RLB)==0);
%% assignment
TrainingSet=new_data;
TrainingSet_Label=new_t;
L=TrainingSet(filterIndex,:);
t=TrainingSet_Label(filterIndex,:);
L=[data(previous,:);L];
t=[label(previous);t];
NoiseDataSet=TrainingSet(NoiseIndex,:);
NoiseDataSet_Label=TrainingSet_Label(NoiseIndex,:);
end

