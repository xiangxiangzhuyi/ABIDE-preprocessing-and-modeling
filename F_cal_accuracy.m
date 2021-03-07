function [all_accuracy, cat_accuracy]=F_cal_accuracy(truth_data, fore_data)
% this function is used to claculate the accuracy of data

fore_data1=zeros(size(fore_data));
[m, index]=max(fore_data);
for i=1:length(fore_data)
    fore_data1(index(i), i)=1;
end
count_data=truth_data*10-fore_data1;
% to count the number of the element with a value of 9 in the count_data. 9
% means correct. 10 means incorrect.
count9=count_data;
count9(count9~=9)=0;
count9(count9==9)=1;
% to count the number of the element with a value of 10 in the count_data
count10=count_data;
count10(count10~=10)=0;
count10(count10==10)=1;
% to calculate the whole accuracy
all9_num=sum(count9(:)); % the number of correct
all10_num=sum(count10(:)); % the number of incorrect
all_accuracy=all9_num/(all9_num+all10_num);
% to calculate the accuracy of each category
cat9_num=sum(count9, 2);
cat10_num=sum(count10, 2);
cat_accuracy=cat9_num./(cat9_num+cat10_num);
end

