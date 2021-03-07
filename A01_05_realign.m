%  In this script, the batch realign tool of SPM 12 will be used to realign
%  the fMRI data that has been sliceed timing.

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
for i=83
    func_folder=[path, '/', path_dir(i).name, '/func/'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        % get the file name of the subject
        filename=func_dir(j).name;
        % judge whether the file is a result preprocessed by slice timing
        if strcmp(filename(1:4), 'asub')&&strcmp(filename(end-2: end), 'nii')
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
        batch_cell={data_cell};
        % give the data path and the parameters to the SPM 12 batch
        index=index+1;
        matlabbatch{index}.spm.spatial.realign.estwrite.data = batch_cell;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{index}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{index}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{index}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{index}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{index}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{index}.spm.spatial.realign.estwrite.roptions.prefix = 'r';        
    end   
end

% use the spm to slice timing
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   


