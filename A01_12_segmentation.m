% This script is used to segemet the brain. There are two purposes for
% segmentation: 1) extract the braintissue, then register the braintissue
% to the mean functional data of subjects with a ineiligible coregistered
% result; 2) get the deformation fields that need to be used in the
% normalization.

% clean up the workspace
clc;
clear;
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
matlabbatch=[];
for i=[13 64]
    anat_folder=[path, '/', path_dir(i).name, '/anat'];
    folder_dir=dir(anat_folder);
    % select the T1w anatomy image
    for j=3:length(folder_dir)
        filename=folder_dir(j).name;
        if strcmp(filename(1:3), 'sub')&&strcmp(filename(end-2:end), 'nii')&&contains(filename, 'T1w')
            anat_filename=[anat_folder, '/', filename];
        end
    end
    % construct the matlabbatch
    index=index+1;
    matlabbatch{index}.spm.spatial.preproc.channel.vols = {[anat_filename, ',1']};
    matlabbatch{index}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{index}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{index}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{index}.spm.spatial.preproc.tissue(1).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,1'};
    matlabbatch{index}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{index}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(2).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,2'};
    matlabbatch{index}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{index}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(3).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,3'};
    matlabbatch{index}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{index}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(4).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,4'};
    matlabbatch{index}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{index}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(5).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,5'};
    matlabbatch{index}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{index}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(6).tpm = {'/data/bridge/toolbox/spm12/tpm/TPM.nii,6'};
    matlabbatch{index}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{index}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{index}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{index}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{index}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{index}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{index}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{index}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{index}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{index}.spm.spatial.preproc.warp.write = [0 1];
end
% use the spm to segment
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   











