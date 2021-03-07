% In the original plan, after the normalization, regression and band pass
% fliter will be implemented, but I don't have enough time to do those
% work, so I decide to directly smooth the normalized result.

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
    % get the file name of the subject
    func_folder=[path, '/', path_dir(i).name, '/func/'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        filename=func_dir(j).name;
        % judge whether the file is a result preprocessed by slice timing
        if strcmp(filename(1:6), 'wrasub')&&strcmp(filename(end-2: end), 'nii')
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
    matlabbatch{index}.spm.spatial.smooth.data = data_cell;
    matlabbatch{index}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{index}.spm.spatial.smooth.dtype = 0;
    matlabbatch{index}.spm.spatial.smooth.im = 0;
    matlabbatch{index}.spm.spatial.smooth.prefix = 's';
end

% use the spm to segment
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);


