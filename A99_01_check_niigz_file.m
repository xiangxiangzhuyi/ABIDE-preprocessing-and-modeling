% I found that there are some files that area still compressed, so I neeed
% to  count and decompressed them.

% clean up the workspace
clc;
clear;
% set path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
for i=3:length(path_dir)
    sub_fullname=[path, '/', path_dir(i).name];
    folder_dir=dir(sub_fullname);
    for j=3:length(folder_dir)
        sess_fullname=[sub_fullname, '/', folder_dir(j).name];
        sess_dir=dir(sess_fullname);
        for k=3:length(sess_dir)
            filename=sess_dir(k).name;
            if strcmp(filename(end-1:end), 'gz')
                disp(filename);
            end
        end
    end

end