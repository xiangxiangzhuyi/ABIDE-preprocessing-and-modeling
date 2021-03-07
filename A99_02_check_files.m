% After the slice timing finished, I saw some error information appeared
% in the command window, so I think I need to check whether the all fMRI
% data have been slice timing.

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
 
% traverse the all subject under the directory
for i=3:length(path_dir)
    sub_name=path_dir(i).name;
    func(i-2).name=sub_name;
    anat(i-2).name=sub_name;
    % get the directory under the functional folder of the subject
    folder_fullname=[path, '/', sub_name, '/func/'];
    folder_dir=dir(folder_fullname);
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        str=['func(i-2).file', num2str(j-2), '=filename;'];
        eval(str);
    end  
    % get the directory under the anatomy folder of the subject
    folder_fullname=[path, '/', sub_name, '/anat/'];
    folder_dir=dir(folder_fullname);
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        str=['anat(i-2).file', num2str(j-2), '=filename;'];
        eval(str);
    end
end





