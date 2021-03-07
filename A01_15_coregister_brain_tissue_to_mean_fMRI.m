% This script is used to register the brain tissue MRI to the mean
% functional MRI, and the position modified parameters are also used to the
% original anatomy MRI

% clean up the worksapce
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
for i=258
    % step1: get the name of the anatomy file
    % get the full path of the anatomy folder
    anat_folder=[path, '/', path_dir(i).name, '/anat'];
    % select the brain tissue anatomy file as the source
    anat_filename=[anat_folder, '/braintissue_', path_dir(i).name, '.nii'];
    % get the full path of the functional folder
    func_folder=[path, '/', path_dir(i).name, '/func'];
    func_dir=dir(func_folder);
    for j=3:length(func_dir)
        filename=func_dir(j).name;
        if strcmp(filename(1:4), 'mean')
            func_filename=[func_folder, '/', filename];
            break;
        end        
    end
    % get the other files
    folder_dir=dir(anat_folder);
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        if strcmp(filename(1:3), 'new')&&strcmp(filename(end-2:end), 'nii')&&contains(filename, 'T1w')
            other_filename{1, 1}=[anat_folder, '/', filename, ',1'];
        end
    end
    % construct the matlab batch
    index=index+1;
    matlabbatch{index}.spm.spatial.coreg.estimate.ref = {[func_filename, ',1']};
    matlabbatch{index}.spm.spatial.coreg.estimate.source = {[anat_filename, ',1']};
    matlabbatch{index}.spm.spatial.coreg.estimate.other = other_filename;
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];     
end

% use the spm to slice timing
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);