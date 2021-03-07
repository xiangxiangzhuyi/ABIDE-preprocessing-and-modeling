% this script is used to select features

% clean up the worksapce
clc;
clear;
% set parameters
select_num=100;
% load data
load('C:/Data/project2/model3_matalab/other_data/Brodmann_61x73x61.mat');
fc_input=fc_input';
fc_output=fc_output';
% using fisher score to select features
[fisher_score, selected_fc_mat]=F_fisher(fc_input, fc_output, select_num);
% classfy
[output_data_fore, all_accuracy, cat_accuracy] = F_Xfold_cross_validation( 4, selected_fc_mat, fc_output);
