% The disk space of the computer is too small. with the increasing of the
% data, the remaining available space is not enough fo another process that
% will produce a lot of data.
% This script is used to delete the data that are not useful anymore

% clean up the workspace
clc;
clear;
% set the path
path='C:\Data\project2\Raw_data\ABIDE 2_raw_data';
path_dir=dir(path);
for i=3:length(path_dir)
    % get the directory of the sit
    sit_fullname=[path, '\', path_dir(i).name];
    sit_dir=dir(sit_fullname);
    for j=3:length(sit_dir)
        sub_folder=sit_dir(j).name;
        if strcmp(sub_folder(1:3), 'sub')
            func_path=[sit_fullname, '\', sub_folder, '\ses-1\func'];
            if ~exist(func_path, 'dir')
                continue;
            end
            func_dir=dir(func_path);
            for k=3:length(func_dir)
                filename=func_dir(k).name;
                if strcmp(filename(end-2: end), 'nii')
                    file_fullname=[func_path, '\', filename];
                    % delete the nii file
                    delete(file_fullname);
                end               
            end
        end        
    end
end