I = im2double(imread('preeastmid_output.tif'));

I=I(3000:3500,3000:3500);%cropping a portion

I=rescale(I);
I = histeq(I);
sz = size(I);

[r, c, v]=find(I>0 & I<0.5);
J=zeros(sz);
for i=1:size(r,1)
    x=r(i); y=c(i);
    count = 0;
    
    for j=-4:4
        for k = -4:4
            if (x+j)>1 && (x+j)<sz(1) && (y+k)>1 && (y+k)<sz(2)
                
                if abs(I(x,y)-I(x+j,y+k))<=0.2         
                    count = count+1;
                end
            end
        end
    end
    if count>=40
               
        J1 = regiongrown(I,x,y,0.02);
        J=J+J1;
    end
end
 
J(J>0)=255;


figure, imshow(imadjust(I));
figure, imshow(imadjust(J));

