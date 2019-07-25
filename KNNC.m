function predict = KNNC( TrainingSet,label,test,K )
%% KNN classification
if nargin==0
    clc
    TrainingSet=[2 1;
                3  3;
                4  4];
    label=[1;1;2]
    test=[1 1;2 2];
    K=2;
end
KNN_idx=knnsearch(TrainingSet,test,'NSMethod','kdtree','K',K);
predict=zeros(size(test,1),1);
for i=1:size(test,1)
    labels=label(KNN_idx(i,:));
    predict(i)=mode(labels);
end
end

