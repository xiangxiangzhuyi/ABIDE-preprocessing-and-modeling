% according to the segmentation of the anatomy MRI, to get the brain tissue
% that will be coregistered to the mean functional MRI

% clean up the workspace
clc;
clear;

% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';
path_dir=dir(path);
% traverse the all data
index=0;
for i=3:length(path_dir)
   anat_folder=[path, '/', path_dir(i).name, '/anat'];
   anat_dir=dir(anat_folder);
   % set1: get the full name of the input files
   for j=3:length(anat_dir)
       filename=anat_dir(j).name;
       file_fullname=[anat_folder, '/', filename];
       if strcmp(filename(1:2), 'c1')
           input{1,1}=[file_fullname, ',1'];
       end
       if strcmp(filename(1:2), 'c2')
           input{2, 1}=[file_fullname, ',1'];
       end
       if strcmp(filename(1:2), 'c3')
           input{3, 1}=[file_fullname, ',1'];
       end
       if strcmp(filename(1:3), 'sub')&&strcmp(filename(end-2: end), 'nii')
           input{4, 1}=[file_fullname, ',1'];
       end       
   end
   % step2: get the name of the output file
   output_filename=['braintissue_', path_dir(i).name];   
   % step3: get the output folder
   index=index+1;
   output_foldername=anat_folder;
   matlabbatch{index}.spm.util.imcalc.input =input ;
    matlabbatch{index}.spm.util.imcalc.output = output_filename;
    matlabbatch{index}.spm.util.imcalc.outdir = {output_foldername};
    matlabbatch{index}.spm.util.imcalc.expression = 'i4.*(i1 +i2 +i3)';
    matlabbatch{index}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{index}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{index}.spm.util.imcalc.options.mask = 0;
    matlabbatch{index}.spm.util.imcalc.options.interp = 1;
    matlabbatch{index}.spm.util.imcalc.options.dtype = 4;    
end

% use the spm to segment
spm('defaults','fmri');
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);   





