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
figure, imshow(imadjust(uint8(IMG_pre)));
figure, imshow(imadjust(uint8(IMG_post)));

fprintf("---------pre---------\nPre Vmin: %f Pre t: %f\n------------------------\n",Vmin_pre,t_pre);
new_IMG_pre=main(IMG_pre,r,c,Vmin_pre,t_pre);
fprintf("---------post----------\nPost Vmin: %f Post t: %f\n------------------------\n",Vmin_post,t_post);
new_IMG_post=main(IMG_post,r,c,Vmin_post,t_post);
fprintf("Done\n");
IMG_inundated=new_IMG_post-new_IMG_pre; % post-pre is inundated area

figure, imshow(imadjust(new_IMG_pre));
figure, imshow(imadjust(new_IMG_post));

% remove small clusters - less than 100 pxl 
% 8 here represent adjacent pixel connectivity - those share edges 
IMG_inundated_final = bwareaopen(IMG_inundated,101,8) ;
IMG_inundated_final=modefilt(IMG_inundated_final,[3,3]); %mode filter to reduce noise
IMG_inundated_final = imfill(IMG_inundated_final,8,"holes"); % fills in binary image where 8 specifies connectivity

% display image
figure, imshow(imadjust(uint8(IMG_inundated_final)));
figure, imshow(imadjust(inundated_result));

%save images
imwrite(uint8(IMG_post),strcat('IMG_post_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');
imwrite(uint8(IMG_pre),strcat('IMG_pre_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');
imwrite(new_IMG_post,strcat('water_post_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');
imwrite(new_IMG_pre,strcat('water_pre_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');
imwrite(IMG_inundated_final,strcat('inundated_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');
imwrite(inundated_result,strcat('inundated_result_',string(row1),'x',string(col1),'_',string(row2),'x',string(col2),'.tif'),'tif');

%find area
pre_area=findArea(new_IMG_pre,r,c)/(10.^6);
inundated_area=findArea(IMG_inundated_final,r,c)/(10.^6); 
%find error percentage
inundated_res_area=findArea(inundated_result,r,c)/(10.^6);
%write area in file
s0=strcat("----------Image eastmid----------Size :",string(row1),'x',string(col1),'_',string(row2),'x',string(col2));
s1=strcat("Total image area: ", num2str(r*c/(10.^4)), " sq km");
s2=strcat("Natural water body area: ",num2str(pre_area)," sq km");
s3=strcat("Calculated Inundated area: ",num2str(inundated_area)," sq km");
s4=strcat("Actual Inundated area: ",num2str(inundated_res_area)," sq km");
writelines(s0,"v3_1_text_output.txt");
writelines(s1,"v3_1_text_output.txt",WriteMode="append"); 
writelines(s2,"v3_1_text_output.txt",WriteMode="append"); 
writelines(s3,"v3_1_text_output.txt",WriteMode="append");
writelines(s4,"v3_1_text_output.txt",WriteMode="append"); 
