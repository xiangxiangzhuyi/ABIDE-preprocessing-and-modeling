% The preprocessing of the fMRI data and the overlaying of multiple
% templates have been completed on bridge system using matlab. Because
% there is no stable tool to calculate functional connectivity, I decide to
% copy the preprocess result to my computer. The next process will be
% implemented in my computer. This script is used to copy data.

% clean up the workspace
clc;
clear;

% set the path
save_path='/ctxmnt/chmcres.hulxz3/default/C/Data/project2/model3_matalab/preprocessed_fMRI/';
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
for i=289:length(path_dir)
    % get the file name of the subject
    sub_num=path_dir(i).name;
    func_folder=[path, '/', sub_num, '/func/'];
    func_dir=dir(func_folder);
    file_fullname=[];
    for j=3:length(func_dir)
        filename=func_dir(j).name;
        % judge whether the file is a result preprocessed by slice timing
        if strcmp(filename(1:7), 'swrasub')&&strcmp(filename(end-2: end), 'nii')
            file_fullname=[func_folder, filename];
            % create the subject folder in my computer
            sub_foldername=[save_path, sub_num];
            mkdir(sub_foldername);
            % copy the file
            copyfile(file_fullname, sub_foldername);
            break;
        else
            continue;
        end 
    end
end