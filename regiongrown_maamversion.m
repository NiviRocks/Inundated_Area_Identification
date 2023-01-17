I = im2double(imread('posteastmid.tif'));
 
I=I(4400:4800,3900:4300);%cropping a portion
I=rescale(I);
I = histeq(I);
sz = size(I);
 
[r, c, v]=find(I>0 & I<0.5);%
J=zeros(sz);
 
for i=1:size(r,1)
    x=r(i); y=c(i);
    J1 = regiongrown(I,x,y,0.02); 
    J=J+J1;
end
 
J(J>0)=255;
 
figure, imshow(imadjust(I));
figure, imshow(imadjust(J));

