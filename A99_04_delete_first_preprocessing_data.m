% After a long pause, I finally make the fMRI data preprocessing steps. I
% decide to preprocess thsoe data again, so those data produced by the
% incorrect preprocessing method need to be deleted. this script is used to
% delete those data.

% clean up the workspace
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
for i=3:length(path_dir)
    sub_folder=[path, '/', path_dir(i).name];
    folder_dir=dir(sub_folder);
    for j=3:length(folder_dir)
        folder2=[sub_folder, '/', folder_dir(j).name];
        folder2_dir=dir(folder2);
        for k=3:length(folder2_dir)
            filename=[folder2, '/', folder2_dir(k).name];
            % delete the file
            delete(filename);
        end
        % remove the folder
        rmdir(folder2);
    end
    % remove the folder
    rmdir(sub_folder);
end







