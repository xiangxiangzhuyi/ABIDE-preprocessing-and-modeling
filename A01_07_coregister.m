

% this script is used to coregister the fMRI data

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
for i=[13 64]
    % step1: get the name of the anatomy file
    % get the full path of the anatomy folder
    anat_folder=[path, '/', path_dir(i).name, '/anat'];
    anat_dir=dir(anat_folder);
    % select the T1w anatomy file as the source
    for j=3:length(anat_dir)
        filename=anat_dir(j).name;
        if contains(filename, 'T1w')
            anat_filename=[anat_folder, '/', filename];
        end
    end
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
    % construct the matlab batch
    index=index+1;
    matlabbatch{index}.spm.spatial.coreg.estimate.ref = {[func_filename, ',1']};
    matlabbatch{index}.spm.spatial.coreg.estimate.source = {[anat_filename, ',1']};
    matlabbatch{index}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{index}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];    
end

% use the spm to slice timing
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   


