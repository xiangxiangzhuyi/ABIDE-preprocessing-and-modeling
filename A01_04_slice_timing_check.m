%  This script is used to check the slice timing result. I think it is
%  important to check the result after each processing step.

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
 
% traverse the all subject under the directory
for i=3:length(path_dir)
    sub_name=path_dir(i).name;
    check_result(i-2).name=sub_name;
    % get the directory under the functional folder of the subject
    folder_fullname=[path, '/', sub_name, '/func/'];
    folder_dir=dir(folder_fullname);
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        if strcmp(filename(1:4), 'asub')
            check_result(i-2).slice_timing=1;
        end
    end   
end
% save the check result
save('/data/bridge/Project_code/other_program/data/check_result', 'check_result');


