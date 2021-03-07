function [fisher, output_features] =F_fisher(features, labels, select_num)
% this function is used to calculate the fisher score of features

fea_num=size(features,1);
sub_num=size(features, 2);
cat_num=max(labels(:));
% sort the labels
[m, n]=sort(labels, 2);
labels=labels(:, n);
features=features(:, n);
% to calculate the mean of the whole data
all_mean=mean(features, 2);
% to calculate the mean of different category features
for i=1:cat_num
    mask=labels;
    mask(find(mask~=i))=0;
    mask(find(mask==i))=1;
    cat_sta(1, i)=sum(mask(:)); % to count the number of different category
    mask1=ones(fea_num,1)*mask;
    cat_features=features.*mask1;
    cat_mean(:,i)=mean(cat_features, 2);
end
% to calculate the inter-class variance
sub=cat_mean-(all_mean*ones(1, cat_num));
squ_sub=sub.*sub.*(ones(fea_num, 1)*cat_sta);
Sb=sum(squ_sub, 2)/sub_num; % inter-class variance
% to calculate the intraclass variance
mat_mean=zeros(fea_num, sub_num);
for i=1:cat_num
    mask=labels;
    mask(find(mask~=i))=0;
    mask(find(mask==i))=1;
    mat_mean=mat_mean+cat_mean(:,i)*mask;
end
cat_sub=features-mat_mean;
Sw=sum(cat_sub.*cat_sub, 2)/sub_num; % intraclass variance
% to calculate the fisher score
fisher=Sb./Sw;
% according to the fisher score, to select the excellent features
[f_m, f_n]=sort(fisher, 'descend');
output_features=features(f_n(1:select_num),:);
end





