% During the preprocessing of the fMRI data, there are some important
% information contained in the json files, so before the process, I need to
% read those json files firstly.

% clean up the workspace
clc;
clear;

% load fMRI scanning configuration
load('E:/Graduation_thesis/experiment/other_data/json.mat');

% set the path
path='E:/Graduation_thesis/experiment/data/';
path_dir=dir(path);
% create a  struct to storage the information of each file
sub_info=struct('sub_num', [], 'set_name', [], 'information', []);
% traverse th all subfolders
index=1;
for i=3:length(path_dir)
    sit_name=path_dir(i).name;
    sit_fullname=[path, '/', sit_name];
    % get the directory under the sit
    sit_dir=dir(sit_fullname);
    
    % find the json file and get the information of the sit
    for j=3:length(sit_dir)
        filename=[sit_fullname, '/', sit_dir(j).name];
        % judge whether the file is a json file
        if strcmp(filename(end-3:end), 'json')
            % read the json file
            % infor = infor;
        end        
    end
    
    % add the information to the struct
    for j=3:length(sit_dir)
        filename=sit_dir(j).name;
        % judge whether the file is a subject file
        if strcmp(filename(1:3), 'sub')
            sub_info(index).sub_num=filename;
            sub_info(index).set_name=sit_name;
            sub_info(index).information=infor;
            % create a sub_num easy to retrieve
            check_cell{index, 1}=filename;
            index=index+1;
        end
    end
    infor=[];
end
% save the statistic information
save('E:/Graduation_thesis/experiment/other_data/sub_info.mat', 'sub_info', 'check_cell');


