% copy the image to avoide delete the coregistered result produced by
% original anatomy MRI

% clean up the workspace
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
for i=258
     % get the full path of the anatomy folder
    anat_folder=[path, '/', path_dir(i).name, '/anat'];
    folder_dir=dir(anat_folder);
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        if strcmp(filename(1:3), 'sub')&&strcmp(filename(end-2:end), 'nii')&&contains(filename, 'T1w')
            anat_filename=[anat_folder, '/', filename];
            % get the new name of the anatomy MRI
            new_anat_filename=[anat_folder, '/new_', filename];
            copyfile(anat_filename, new_anat_filename);
        end
    end   
end