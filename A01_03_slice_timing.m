% based on the information readed from json files, this script is used to
% slice timing of the fMRI data through the batch function.

% clean up the workspace
clc;
clear;

% load the information of the subject
load('E:/Graduation_thesis/experiment/other_data/sub_info.mat');

% set the path
path='E:/Graduation_thesis/experiment/data/EMC_1';
path_dir=dir(path);

% traverse the all files
index=0;
for i = 3:length(path_dir)
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
        if ~strcmp(file_fullname(end-5:end), 'ed.nii')
            continue;
        end
        %step2: get the number of the volume contains in the file
        stru_img=load_untouch_nii(file_fullname);
        mul_volume=stru_img.img;
        tim_len=size(mul_volume, 4);   
        % step3: create the cell contains the full name of the fMRI data
        for k=1:tim_len
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