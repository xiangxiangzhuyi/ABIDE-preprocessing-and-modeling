% After realign, we need to check the result

% clean up the workspace
clc;
clear;
 % load data
load('/data/bridge/Project_code/other_program/data/check_result');
% set the path
path='/data/bridge/Project_code/other_program/ABIDE2';

% traverse the all data
index=0;
for i=1:length(check_result)
    % get to know whether the subject has gotten the last preprocess
    if check_result(i).slice_timing==1
        % we know that all fMRI data has beeen preprocessed completely
        % get the full name of the functional folder
        func_fullname=[path, '/', check_result(i).name, '/func'];
        func_dir=dir(func_fullname);
        % to get the name of the montion text
        for j=3:length(func_dir)
            filename=[func_fullname, '/', func_dir(j).name];
            if strcmp(filename(end-2: end), 'txt')
                b=load(filename); % load data from the txt file
                plot(b);
                c=max(abs(b));
                c(4:6)=c(4:6)*180/pi;
                % according to the montion and rotation, judge whether
                % remove the subject
                if max(c)<=2
                    check_result(i).realign=1;
                    index=index+1;
                else
                    check_result(i).realign=0;
                end
            end
        end       
    end   
end
% save the result
save('/data/bridge/Project_code/other_program/data/check_result', 'check_result');