function [con_labels]=F_convert_labels(labels)
% this sub-function is used to convert the single number label of a subject
% to a vector
cat_num=max(labels(:));
sub_num=size(labels, 2);
con_labels=zeros(cat_num, sub_num); % note: A row represent all values of a feature. A Column represent all features of a subject
for i=1:length(labels)
    con_labels(labels(i), i)=1;
end
end

