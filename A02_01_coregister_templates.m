% the dimension of the fMRI is 61x73x61, and the voxel size is 3x3x3. in
% order to overlay the fMRI data, the template should has the same
% dimension and the same voxel size. This script is used to coregister
% other templates to the Brodmann template

% clean up the workspace
clc;
clear;

% ste the path
path= '/data/bridge/Project_code/other_program/Reference_templates';
path_dir=dir(path);

% traverse the all templates
index=0;
matlabbatch=[];
for i=3:length(path_dir)
    filename=path_dir(i).name;
    if strcmp(filename, 'Brodmann_61x73x61.nii')
        continue;
    end
    file_fullname=[path, '/', path_dir(i).name];
    % use SPM12 toolbox to complete coregister
    index=index+1;
    matlabbatch{index}.spm.spatial.coreg.estwrite.ref = {'/data/bridge/Project_code/other_program/Reference_templates/Brodmann_61x73x61.nii,1'};
    matlabbatch{index}.spm.spatial.coreg.estwrite.source = {[file_fullname, ',1']};
    matlabbatch{index}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{index}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{index}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{index}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{index}.spm.spatial.coreg.estwrite.eoptions.fwhm = [1 1];
    matlabbatch{index}.spm.spatial.coreg.estwrite.roptions.interp = 0;
    matlabbatch{index}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{index}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{index}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
end

% use the spm to segment
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);
