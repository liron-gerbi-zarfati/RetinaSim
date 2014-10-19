clc
clear all
close all
%% Parameters
direction='right'; %up%down%left%right
pix=16;           %number of pixels in one phosphene, even number only   

%% The image
h_im=384; %the height of the image
w_im=384; %the width of the image
T=w_im/4; %the width of the rectangle
t=10;     %the width of the small rect
edg=(w_im-T)/2;

image=zeros(h_im,w_im);
image(edg+1:edg+T, edg+1:edg+T)=0.5;
image(edg-t+1:edg,((w_im-t)/2+1):((w_im-t)/2+t))=0.5;


switch direction
    case 'up'
        image=image;
    case 'left'
        image=imrotate(image,90);
    case 'down'
        image=imrotate(image,180);
    case 'right'
        image=imrotate(image, 270);
end
imshow(image,[0,1]);
%% The filter
hsize = pix;  %only an even number
sigma = hsize^0.5;
h = fspecial('gaussian', hsize, sigma);
imshow(h,[]);
%% filter by IMFILTER function
blur_im = imfilter(image,h,'replicate');
imshow(blur_im,[0,1]);

%% sampling of the picture
sample_im=zeros(h_im,w_im);
last_sample=h_im-16+1;
for i=1:pix:last_sample
    for j=1:pix:last_sample
        sample_im(i:i+pix-1,j:j+pix-1)=blur_im(i+pix-1,j+pix-1);
    end
end
imshow(sample_im,[]);

%% create phosphenes
pix_no=h_im/pix; %number of phosphenes
Phosphene_Matrix=repmat(h,pix_no,pix_no);
imshow(Phosphene_Matrix,[]);


phosphene_image=sample_im.*Phosphene_Matrix;
imshow(phosphene_image,[]);

