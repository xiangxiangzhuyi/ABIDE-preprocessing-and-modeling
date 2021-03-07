% this script is used to overlay multiple templates. I saved the overlapped
% image matrix to a mat file before, but now I need to save the result to
% a nifti file.

% clean up the workspace
clc;
clear;
% get coregistered templates
path='/data/bridge/Project_code/other_program/Reference_templates';
tem_name={'rAutomated Anatomical Labeling (Tzourio-Mazoyer 2002).nii';...
    'Brodmann_61x73x61.nii'};
% read files
index=1;
for i=1:length(tem_name)
    % according to whether the first letter is 'r', to judge whether this file has been coregistered
    file_name=tem_name{i, 1};
    file_fullname=[path, '/', file_name];
    % read nii file
    V = spm_vol_nifti(file_fullname);
    templates(:,:,:,index)= spm_read_vols(V);
    index=index+1;
end

% combine multiple templates to a single template
[ temp, label_num ] = F_combine_templates( templates);
% get the name of the nifti file
com_name=[];
for i=1:length(tem_name)
    file_name=tem_name{i, 1};
    com_name=[file_name(1:4), '_', com_name];    
end
com_name=[com_name, '.nii'];
% save template as nifti file
V.fname=['/ctxmnt/chmcres.hulxz3/default/C/Data/project2/model3_matalab/com_template/', com_name];
V.dt=[8, 0];
spm_write_vol(V,temp);



