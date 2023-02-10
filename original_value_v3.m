IMG_post = double(imread('posteastmid.tif'));
IMG_pre = double(imread('preeastmid_output.tif'));
inundated_result = im2double(imread('inundation_image.tif'));
row=4200; col=6200;
IMG_post=IMG_post(row:col,row:col); %cropping a portion
IMG_pre=IMG_pre(row:col,row:col);
inundated_result=inundated_result(row:col,row:col);

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


%figure, imshow(imadjust(new_IMG_pre));
%figure, imshow(imadjust(new_IMG_post));
%figure, imshow(imadjust(IMG_inundated));

IMG_inundated_mode=modefilt(IMG_inundated,[5,5]); %mode filter to reduce noise
%figure, imshow(imadjust(IMG_inundated_mode));
%figure, imshow(imadjust(inundated_result));

%save images
imwrite(uint8(IMG_post),strcat('IMG_post_',string(row),'x',string(col),'.tif'),'tif');
imwrite(uint8(IMG_pre),strcat('IMG_pre_',string(row),'x',string(col),'.tif'),'tif');
imwrite(new_IMG_post,strcat('water_post_',string(row),'x',string(col),'.tif'),'tif');
imwrite(new_IMG_pre,strcat('water_pre_',string(row),'x',string(col),'.tif'),'tif');
imwrite(IMG_inundated_mode,strcat('inundated_',string(row),'x',string(col),'.tif'),'tif');
imwrite(inundated_result,strcat('inundated_result_',string(row),'x',string(col),'.tif'),'tif');

%find area
pre_area=findArea(new_IMG_pre,r,c)/(10.^6);
inundated_area=findArea(IMG_inundated_mode,r,c)/(10.^6); 
%find error percentage
inundated_res_area=findArea(inundated_result,r,c)/(10.^6);
%write area in file
s0=strcat("----------Image eastmid----------Size :",string(row),"x",string(col));
s1=strcat("Total image area: ", num2str(r*c/(10.^4)), " sq km");
s2=strcat("Natural water body area: ",num2str(pre_area)," sq km");
s3=strcat("Calculated Inundated area: ",num2str(inundated_area)," sq km");
s4=strcat("Actual Inundated area: ",num2str(inundated_res_area)," sq km");
writelines(s0,"v6_text_output.txt",WriteMode="append");
writelines(s1,"v6_text_output.txt",WriteMode="append"); 
writelines(s2,"v6_text_output.txt",WriteMode="append"); 
writelines(s3,"v6_text_output.txt",WriteMode="append");
writelines(s4,"v6_text_output.txt",WriteMode="append"); 

%function main
function [new_IMG]=main(IMG,r,c,Vmin,t)
    new_IMG=zeros(r,c);
    for x = 1:r
        for y = 1:c
            if ~new_IMG(x,y) %if pixel not marked water
                if IMG(x,y)>=Vmin && IMG(x,y)<=t+Vmin %check within threshold
                    [new_t]=threshold_shift(IMG,r,c,x,y,t,Vmin); %get new threshold
                    if new_t ~=-1 % new_t == -1 then pixel is not water
                        J1 = regiongrown(IMG,x,y,new_t); %using new local threshold
                        new_IMG=new_IMG+J1;
                        if mod(x,5)==0 && mod(y,200)==0
                            figure, imshow(imadjust(new_IMG));
                        end
                    end
                end
            end
        end
    end
    new_IMG(new_IMG>0)=255;
    % non zero pixel - not water (255 - white)
end

% function to check if pixel is water
function [result,mean] = isWater(IMG,r,c,x,y,t,Vmin)
    count=0; mean=0;
    for j = -2:2 % window row
        for k = -2:2 % window col            
            if (x+j)>1 && (x+j)<r && (y+k)>1 && (y+k)<c % if pixel within image
                pxl_value=IMG(x+j,y+k);
                if pxl_value>=Vmin && pxl_value<=t+Vmin  % if pixel value in [Vmin,Vmin+t]
                    count = count+1; % count water pixels
                    mean=mean+pxl_value;
                end
            end
        end
    end
    mean=mean/count;
    if count>=12 % if water pixel more than 50% in window
        result = 1; % true
    else 
        result = 0; % false
    end
end 

% function for threshold shifting
function [new_t] = threshold_shift(IMG,r,c,x,y,t,Vmin)
    new_t=t+1;
    [isw1,m1]=isWater(IMG,r,c,x,y,t,Vmin); %mean for global threshold
    [isw2,m2]=isWater(IMG,r,c,x,y,new_t,Vmin); %mean for t1'
    if isw1==0 && isw2==0 %if pixel not water return -1
        new_t=-1;
    else
        while abs(m1-m2)>=0.1 && isw1 && isw2 
            m1=m2; isw1=isw2;
            new_t=new_t+1;
            [isw2,m2]=isWater(IMG,r,c,x,y,new_t,Vmin);
        end
    end
end

%function for area of inundated image
function [area]=findArea(IMG,r,c)
    area=0;
    for x=1:r
        for y=1:c
            if IMG(x,y)
                area=area+100;
            end
        end
    end
end
