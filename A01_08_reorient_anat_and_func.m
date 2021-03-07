% This script is used to display the anatomy images that need to be
% reoriented. Note: the work writing the origin modification to the anatomy
% and functional images is completed manually.

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=289;
for i=1:1000
    anat_folder=[path, '/', path_dir(index).name, '/anat'];
    anat_dir=dir(anat_folder);
    % select the T1w anatomy file as the source
    for j=3:length(anat_dir)
        filename=anat_dir(j).name;
        if contains(filename, 'T1w')
            anat_filename=[anat_folder, '/', filename];
        end
    end
    spm_image('Init', anat_filename);
    input([anat_folder, '   :']);
    index=index+1;
end



