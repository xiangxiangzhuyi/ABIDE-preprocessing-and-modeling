% zip nii files to nii.gz files to give more disk space

% clean up the worksapce
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);

% traverse all data
for i=3:length(path_dir)
    sub_name=[path, '/', path_dir(i).name];
    sub_dir=dir(sub_name);
     
    % traverse all folders uner the subject
    for j=3:length(sub_dir)
        folder_name=[sub_name, '/', sub_dir(j).name];
        folder_dir=dir(folder_name);
        
        % traverse all files under the folder
        for k=3:length(folder_dir)
            filename=[folder_name, '/', folder_dir(k).name];
            % judge whether the file could be compressed
                if strcmp(filename(end-2:end), 'nii')
                    gzip(filename); 
                    % if compressing the file successful, delete the original file.
                    compressed_file=[filename, '.gz'];
                    if exist(compressed_file, 'file') ==2
                        delete(filename);
                    end       
                end                
        end       
    end    
end




