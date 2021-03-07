function [output_data_fore, all_accuracy, cat_accuracy] = F_Xfold_cross_validation( xfold, input_data, output_data)
% X fold cross validation

% store data randomly
k=rand(1, size(output_data, 2));
[m, n]=sort(k);
input_data=input_data(:, n);
output_data=output_data(:, n);
sub_num=size(input_data, 2); % the number of subjects
batch_num=floor(sub_num/xfold);
addition_num=sub_num-batch_num*xfold;
% start cross vaildation
sum_num=0;
output_data_fore=[];
for i=1:xfold
    if i<=addition_num
        each_num=batch_num+1;
    else
        each_num=batch_num;
    end
    % to split the train data and the test data
    test_input=input_data(:, sum_num+1:sum_num+each_num);
    test_output=output_data(:, sum_num+1:sum_num+each_num);
    train_input=input_data(:, [1: sum_num, sum_num+each_num+1: sub_num]);
    train_output=output_data(:, [1: sum_num, sum_num+each_num+1: sub_num]);
    % train and test
    [train_output_fore,test_output_fore] = F_classify_BP(train_input, train_output, test_input, test_output);
    output_data_fore=[output_data_fore, test_output_fore];    
    sum_num=sum_num+each_num;
end
% to convert the form of the labels
output_data1=F_convert_labels(output_data);
% calculate the accuracy
[all_accuracy, cat_accuracy]=F_cal_accuracy(output_data1, output_data_fore);
end

