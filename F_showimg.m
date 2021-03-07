function [  ] = showimg( img,index)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
x=size(img,1);
y=size(img,2);
z=size(img,3);
inx=floor(((z/15)^0.5)*3)+1;
iny=floor(((z/15)^0.5)*5)+1;
if index==0
    for i=1:z
        img1=reshape(img(:,:,i),1,x*y);
        subplot(inx,iny,i);
        img2=mapminmax(double(img1),0,255);
        img3=reshape(img2,x,y);
        img4=uint8(img3);
        imshow(img4);
    end
else
    img1=reshape(img(:,:,index),1,x*y);
    img2=mapminmax(double(img1),0,255);
    img3=reshape(img2,x,y);
    img4=uint8(img3);
    subplot(1,2,1);
    imshow(img4);
    subplot(1,2,2);
    mesh(img(:,:,index));
end
end


