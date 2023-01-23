IMG = im2double(imread('posteastmid.tif'));

IMG=IMG(4400:4800,3900:4300); %cropping a portion

IMG=rescale(IMG); %rescale 0-1
IMG = histeq(IMG); 
sz = size(IMG);

[r, c, v]=find(IMG>0 & IMG<0.5); %assumed range for water pixel values
new_IMG=zeros(sz);

t=0.2; %assumed threshold 
mean_diff = 0.1 ; % mean difference range
% { t=0.3186 (-4:4) reduced by 0.01 for 4400:4800,3900:4300} (output 2)
% { t=0.42 (-3:3) reduced by 0.01 for 4200:4600,3700:4100}
% { t=0.3 (-3:3) reduced by 0.01 for 4000:4800,3500:4300} (output 1)
% { t=0.2 (-3:3) increased by 0.01 for 4400:4800,3900:4300 and mean
% difference range increased by } BEST (output 3)
Vmin = 1; % minimum pixel value that is water
prev_m=0; ct=0;

% find minimum pixel value and mean of image
for i = 1:size(r,1)
    x=r(i); y=c(i);
    ct=ct+1; 
    prev_m=prev_m+IMG(x,y);
    if IMG(x,y) < Vmin %&& isWater(x,y,IMG,sz,t)
        Vmin = IMG(x,y);
    end
end
prev_m=prev_m/ct;
fprintf("Vmin %f prev_m %f t %f\n\n",Vmin,prev_m,t);

temp=0;
for i=1:size(c,1)
    y=r(i); x=c(i);
    count = 0; %count number of water pixel in window
    [answ, new_m ]= isWater(x,y,IMG,sz,t);
    if answ == 1
        fprintf("x %d y %d answ %d new_m %f mean diff %f",x,y,answ,new_m,mean_diff);
        J1 = regiongrown(IMG,x,y,t); % region growing
        new_IMG=new_IMG+J1;
        if abs(new_m - prev_m) >= mean_diff % Adaptive method 
            t=t+0.01; % threshold shift
            mean_diff=mean_diff+0.005;
            fprintf("t %f",t);
            figure, imshow(imadjust(new_IMG));
        else 
            temp=temp+1;
            if temp>1000
                break
            end
        end
        prev_m=new_m;
        fprintf("\n");
    end
    mean_diff=mean_diff+0.0001;
end
 
new_IMG(new_IMG>0.2)=255;
% non zero pixel - not water (255 - white)

figure, imshow(imadjust(IMG));
figure, imshow(imadjust(new_IMG));

% function to check if pixel is water
function [result,mean] = isWater(x,y,IMG,sz,t)
    mean=0;
    count=0;
    for j = -3:3 % window row
        for k = -3:3 % window col
            % if pixel within image
            if (x+j)>1 && (x+j)<sz(1) && (y+k)>1 && (y+k)<sz(2)
                % if pixel value in threshold
                if abs(IMG(x,y)-IMG(x+j,y+k))<=t %&& abs(IMG(x,y)-IMG(x+j,y+k))>= Vmin     
                    count = count+1; % count water pixels
                    mean=mean+IMG(x+j,y+k);
                else
                    %fprintf("\nin2 vmin %f t %f",abs(IMG(x,y)-IMG(x+j,y+k)),abs(IMG(x,y)-IMG(x+j,y+k)));
                end
            else
                %fprintf("in1 %d %d\n",x,y);
            end
            %fprintf("mean %f\n",mean);
        end
    end
    mean=mean/count;
    if count>=40 % if water pixel more than 50% in window
        result = 1; % true
    else 
        result = 0; % false
    end
end 
