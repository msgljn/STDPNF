function predict = KNNC( TrainingSet,label,test,K )
KNN_idx=knnsearch(TrainingSet,test,'NSMethod','kdtree','K',K);
predict=zeros(size(test,1),1);
for i=1:size(test,1)
    labels=label(KNN_idx(i,:));
    predict(i)=mode(labels);
end
end

