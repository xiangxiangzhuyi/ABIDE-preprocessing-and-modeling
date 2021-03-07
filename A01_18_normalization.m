% this script is used to noramalize the functional data based on the
% deformation field that is created in previous process

% clean up the workspace
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
matlabbatch=[];
for i=3:length(path_dir)
    % get the full path of the anatomy folder
    anat_folder=[path, '/', path_dir(i).name, '/anat'];
    anat_dir=dir(anat_folder);
    for j=3:length(anat_dir)
        filename=anat_dir(j).name;
        if strcmp(filename(1:5), 'y_new')&&contains(filename, 'nii')
            def_filename=[anat_folder, '/', filename];
        end        
    end    
    % get the file name of the subject
    func_folder=[path, '/', path_dir(i).name, '/func/'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        filename=func_dir(j).name;
        % judge whether the file is a result preprocessed by slice timing
        if strcmp(filename(1:5), 'rasub')&&strcmp(filename(end-2: end), 'nii')
            file_fullname=[func_folder, filename];
        else
            continue;
        end        
        % get the number of the volumes in the fMRI data
        stru_img=load_untouch_nii(file_fullname);
        mul_volume=stru_img.img;
        tim_len=size(mul_volume, 4); 
        % create the cell contains the fMRI data full path
        data_cell={};
        for k=1:tim_len
            data_cell=[data_cell; [file_fullname, ',', num2str(k)]];
        end
    end
    % construct the matlabbatch
    index=index+1;
    %%
    matlabbatch{index}.spm.spatial.normalise.write.subj.def = {def_filename};
    matlabbatch{index}.spm.spatial.normalise.write.subj.resample = data_cell;
    matlabbatch{index}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                                                              90 90 108];
    matlabbatch{index}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
    matlabbatch{index}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{index}.spm.spatial.normalise.write.woptions.prefix = 'w';
    %%
end

% use the spm to segment
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   





