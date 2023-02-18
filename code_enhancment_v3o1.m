IMG_post = double(imread('posteastmid.tif'));
IMG_pre = double(imread('preeastmid_output.tif'));
inundated_result = im2double(imread('inundation_image.tif'));
row1=5000; row2=6000; col1=2000; col2=3400;
IMG_post=IMG_post(row1:row2,col1:col2); %cropping a portion
IMG_pre=IMG_pre(row1:row2,col1:col2);
inundated_result=inundated_result(row1:row2,col1:col2);

[r,c] = size(IMG_pre); %size of post and pre image is the same

%assumed threshold (-2sd)
t_post=std(IMG_post,0,"all")/2; 
t_pre=std(IMG_pre,0,"all")/2;
%find minimum pixel value
Vmin_post = min(IMG_post,[],"all");
Vmin_pre = min(IMG_pre,[],"all");
