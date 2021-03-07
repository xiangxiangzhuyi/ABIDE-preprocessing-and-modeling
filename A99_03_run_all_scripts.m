% based on the information readed from json files, this script is used to
% slice timing of the fMRI data through the batch function.

% clean up the workspace
clc;
clear;

% load the information of the subject
load('/data/bridge/Project_code/other_program/data/sub_info.mat');

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);

% traverse the all files
index=0;
for i=3:length(path_dir)
    % get the subject numner
    sub_num=path_dir(i).name;
    % get the full path of the functional folder
    func_folder_fullname=[path, '/', sub_num, '/func'];
    func_dir=dir(func_folder_fullname);
    for j=3:length(func_dir)
        % part1: create the input file cell
        filename=func_dir(j).name;
        if ~strcmp(filename(1:3), 'sub')
            continue;
        end
        % step1: get the full name of the functional data
        file_fullname=[func_folder_fullname, '/', func_dir(j).name];   
        %step2: get the number of the volume contains in the file
         stru_img=load_untouch_nii(file_fullname);
        mul_volume=stru_img.img;
        tim_len=size(mul_volume, 4);   
        % step3: create the cell contains the full name of the fMRI data
        for k=7:tim_len
            namecell{k, 1}=[file_fullname, ',', num2str(k)];           
        end
        namecells{1, 1}=namecell;
        
        % part2: get the information from the struct
        check_res=strcmp(check_cell, sub_num);
        [m, check_index]=max(check_res);
        info_strcut=sub_info(check_index).information;
        
        % part3: according to the result, get the parameters
        slice_num=size(mul_volume, 3);
        TR=info_strcut.RepetitionTime;
        TA=TR-TR/slice_num;
        % check the field
        if ~isfield(info_strcut, 'SliceTiming')
            continue;
        end
        % get the slice order
        slice_acqu_order=info_strcut.SliceTiming;
        [m, n]=sort(slice_acqu_order);
        slice_order=n';
        % get the reference slice
        reference_num=slice_order(floor(length(slice_order)/2));
        
        % part4: add theose information to the matlabbatch
        index=index+1;
        matlabbatch{index}.spm.temporal.st.scans = namecells';
        matlabbatch{index}.spm.temporal.st.nslices = slice_num;
        matlabbatch{index}.spm.temporal.st.tr = TR;
        matlabbatch{index}.spm.temporal.st.ta = TA;
        matlabbatch{index}.spm.temporal.st.so = slice_order;
        matlabbatch{index}.spm.temporal.st.refslice = reference_num;
        matlabbatch{index}.spm.temporal.st.prefix = 'a';       
    end   
end

% use the spm to slice timing
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   



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
for i=115:length(path_dir)
    func_folder=[path, '/', path_dir(i).name, '/func/'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        % get the file name of the subject
        filename=func_dir(j).name;
        % judge whether the file is a result preprocessed by slice timing
        if strcmp(filename(1:4), 'asub')
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