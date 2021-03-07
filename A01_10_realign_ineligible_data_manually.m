% In order to  make those ineligible data available again, I need to
% reorient those functional data again, and then coregister. 

% clean up the workspace
clc;
clear;
% load the check result
load('/data/bridge/Project_code/other_program/data/check_result');
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
for i=3:length(path_dir)
    % judge whether the functional data of the subject need to reorient
    % again.
    if check_result(i-2).coregister~=0
        continue;
    end    
    anat_folder=[path, '/', path_dir(i).name, '/func'];
    anat_dir=dir(anat_folder);
    % select the T1w anatomy file as the source
    for j=3:length(anat_dir)
        filename=anat_dir(j).name;
        if contains(filename, 'mean')
            anat_filename=[anat_folder, '/', filename];
        end
    end
    spm_image('Init', anat_filename);
    input([anat_folder, '   :']);
    index=index+1;
end