function [ varargout ] = F_combine_templates( templates )
%   this function is used to combine multiple templates to a single template
ind_x=size(templates,1);
ind_y=size(templates,2);
ind_z=size(templates,3);
ind_n=size(templates,4);
% the composite template
com_template=zeros(ind_x, ind_y, ind_z);
% to find out the NAN, which will be assigned 0.
templates(find(isnan(templates)))=0;
% cross the whole volume, to find out different combinations of multiple
% templates
index=1;
com_styles(1,:)=zeros(1,ind_n);
style_labels(1,1)=0;
for i=1:ind_x
    for j=1:ind_y
        for k=1:ind_z
            % get labels of all templates
            labels=reshape(templates(i,j,k,:),1,ind_n);
            flag=0;
            % to find out whether com_style have the same labels
            % combination
            for m=1:index
                if isequal(com_styles(m,:), labels)
                    flag=1;
                    com_template(i,j,k)=style_labels(m,1);
                    break;
                end
            end
            if flag==0
                com_styles=[com_styles; labels];
                style_labels=[style_labels; index];
                com_template(i,j,k)=index;
                index=index+1;
            end
        end
    end
end
varargout{1}=com_template;
varargout{2}=index;
end