function Pre=Self_Training(L,t,U,sort_idx,NaNE)
%%  Use a self-traning method to predict the class label of unlabeled natural neighbors
%% Initialize parameters
count=1;
Pre=zeros(size(U,1),1);
M_z=[];
while 1
    %% ��������ó��ޱ������
    index=find(sort_idx==count);
    %%
    classifyU=U(index,:);
    KNN_label=KNNC(L,t,classifyU,NaNE);
    %% update L and U
    Pre(index)=KNN_label;
    for i=1:length(index)
        L=[L;U(index(i),:)];
        t=[t;KNN_label(i)];  
    end
    %% Stopping condition
    pos=find(Pre==0);
    M_z(count)=length(pos);
    if length(pos)==0   % ���ȫ��Ԥ���꣬��ֹͣ
        break;
    else  % Ϊ�˼��ٵ���
        if count>2
            if M_z(count-1)==M_z(count)
               sort_idx(pos)=count+1;
            end
        end
    end
    count=count+1;
end
end