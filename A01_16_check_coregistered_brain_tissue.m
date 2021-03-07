% After the coregister of the brain tissue, I need to check the result
% manually, then implement the normalization program.

% clean up the workspace
clc;
clear;
% set the numer of the functional MR images selected randomly
rand_num=1;
% load check result
load('/data/bridge/Project_code/other_program/data/check_result');
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
for i=1:10000
    % step1: get the full path of the anatomy MRI file
    anat_folder=[path, '/', path_dir(index+2).name, '/anat'];
    anat_dir=dir(anat_folder);
    % select the new T1w anatomy file as the source
    for j=3:length(anat_dir)
        filename=anat_dir(j).name;
        if contains(filename, 'T1w')&&contains(filename, 'new')
            anat_filename=[anat_folder, '/', filename];
        end
    end
    braintisue_filename=[anat_folder, '/braintissue_', path_dir(index+2).name, '.nii'];
    % step2: get the full path of the functional MRI
    func_folder=[path, '/', path_dir(index+2).name, '/func'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        filename=func_dir(j).name;
        % step2.1 get full path of the mean functional MRI
        if strcmp(filename(1:4), 'mean')
            func_mean_filename=[func_folder, '/', filename];
        end
        % step2.2: get the full path of some functional MRI selected randomly
        if strcmp(filename(1:5), 'rasub')&&strcmp(filename(end-2:end), 'nii')
            func_filename=[func_folder, '/', filename];
            % get the number of the volumes in the fMRI data
            stru_img=load_untouch_nii(func_filename);
            mul_volume=stru_img.img;
            tim_len=size(mul_volume, 4);
            func_cell=[];
            for k=1:rand_num
                selected_num=floor(rand(1,1)*tim_len)+1;
                func_cell{k, 1}=[func_filename, ', ', num2str(selected_num)];
            end
        end        
    end
    % step3: put those full path to a function string
    str='spm_check_registration(anat_filename, braintisue_filename, func_mean_filename ';
    for j=1:length(func_cell)
        str=[str, ',func_cell{', num2str(j), ', 1}'];
    end
    str=[str, ');'];
    % step4: use the Spm12 function to the check the coregister result
    eval(str); 
    % step5: input your check result
    check_num=input('input your check result: ');
    if check_num==-1
        % go back one step
        index=index-1;
    else
        % stroe the check result
        check_result(index).braintissue_coregister=check_num;
        index=index+1;
    end
    % step6: save the check result
    save('/data/bridge/Project_code/other_program/data/check_result', 'check_result', 'index');
end