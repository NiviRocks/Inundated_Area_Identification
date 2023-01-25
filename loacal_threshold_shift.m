IMG_post = im2double(imread('subsetpost.tif'));
IMG_pre = im2double(imread('subsetpre.tif'));
inundated_result = im2double(imread('inundation_image.tif'));

IMG_post = rescale(IMG_post); %rescale 0-1
IMG_post = histeq(IMG_post);
%IMG_post = modefilt(IMG_post);

IMG_pre = rescale(IMG_pre); %rescale 0-1
IMG_pre = histeq(IMG_pre); 
%IMG_pre = modefilt(IMG_pre);

[r,c] = size(IMG_pre); %size of post and pre image is the same

t=0.2; %assumed threshold 
%find minimum pixel value
Vmin_post = min(min(IMG_post));
Vmin_pre = min(min(IMG_pre));
fprintf("Pre Vmin: %f\nPost Vmin: %f",Vmin_pre,Vmin_post);

new_IMG_post=main(IMG_post,r,c,Vmin_post,t);
new_IMG_pre=main(IMG_pre,r,c,Vmin_post,t);
fprintf("Done\n");
IMG_inundated=new_IMG_post-new_IMG_pre; % post-pre is inundated area

figure, imshow(imadjust(IMG_post));
figure, imshow(imadjust(IMG_pre));
figure, imshow(imadjust(new_IMG_post));
figure, imshow(imadjust(new_IMG_pre));
%figure, imshow(imadjust(IMG_inundated));

IMG_inundated_mode=modefilt(IMG_inundated,[3,3]); %mode filter to reduce noise
figure, imshow(imadjust(IMG_inundated_mode));
figure, imshow(imadjust(inundated_result));

%save images
%imwrite(new_IMG_post,'IMG_post_eastMid.tiff','tiff');
%imwrite(new_IMG_pre,'IMG_pre_eastMid.tiff','tiff');
%imwrite(IMG_inundated,'IMG_inundated_eastMid.tiff','tiff');
%imwrite(IMG_inundated_mode,'IMG_inundated_mode_eastMid.tiff','tiff');

%find area
pre_area=findArea(new_IMG_pre,r,c)/(10.^6);
inundated_area=findArea(IMG_inundated_mode,r,c)/(10.^6); 
%write area in file
s1=strcat("Total image area: ", num2str(r*c/(10.^4)), " sq km");
s2=strcat("Natural water body area: ",num2str(pre_area)," sq km");
s3=strcat("Inundated area: ",num2str(inundated_area)," sq km");
%writelines(s1,"area_eastMid.txt"); 
%writelines(s2,"area_eastMid.txt",WriteMode="append");
%writelines(s3,"area_eastMid.txt",WriteMode="append");

%function main
function [new_IMG]=main(IMG,r,c,Vmin,t)
    new_IMG=zeros(r,c);
    for y = 1:c
        for x = 1:r
            if ~new_IMG(x,y) %if pixel not marked water
                if IMG(x,y)>=Vmin && IMG(x,y)<=t+Vmin %check within threshold
                    [new_t]=threshold_shift(IMG,r,c,x,y,t,Vmin); %get new threshold
                    if new_t ~=-1 %if new_t == -1 then pixel is not water
                        J1 = regiongrown(IMG,x,y,new_t); %using new local threshold
                        new_IMG=new_IMG+J1;
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
    for j = -3:3 % window row
        for k = -3:3 % window col            
            if (x+j)>1 && (x+j)<r && (y+k)>1 && (y+k)<c % if pixel within image
                pxl_value=IMG(x+j,y+k);
                if pxl_value>=Vmin && pxl_value<=t+Vmin  % if pixel value in [Vmin,Vmin+t]
                    count = count+1; % count water pixels
                    mean=mean+pxl_value;
                end
            end
        end
    end
    if count>=25 % if water pixel more than 50% in window
        result = 1; % true
    else 
        result = 0; % false
    end
end 

% function for threshold shifting
function [new_t] = threshold_shift(IMG,r,c,x,y,t,Vmin)
    new_t=t+0.0001;
    [isw1,m1]=isWater(IMG,r,c,x,y,t,Vmin); %mean for global threshold
    [isw2,m2]=isWater(IMG,r,c,x,y,new_t,Vmin); %mean for t1'
    if isw1==0 || isw2==0 %if pixel not water return -1
        new_t=-1;
    else
        while abs(m1-m2)>=0.05 && isw1 && isw2 
            m1=m2; isw1=isw2;
            new_t=new_t+0.0001;
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



%IMG_post=IMG_post(5000:6500,5000:5500); %cropping a portion
%IMG_pre=IMG_pre(5000:6500,5000:5500);
%inundated_result=inundated_result(5000:6500,5000:5500);
                 
