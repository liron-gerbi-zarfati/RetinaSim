clc
clear all
close all
%% Parameters
direction='right'; %up %down %left %right
position='7';      %1 %2 %3 %4 %5 %6 %7
pix=16;            %number of pixels in one phosphene, even number only   

%% The square's parameters
h_im=400; %the height of the image
w_im=400; %the width of the image
T=150;    %the width of the rectangle - max value is 200
t=12;     %the width of the small rect
min_edg_x=35;
min_edg_y=35;
square_col=0.5;
%% Design the image

switch position
    case '1'
        edg_x=min_edg_x;
        edg_y=min_edg_y;
    case '2'
        edg_x=min_edg_x;
        edg_y=ceil((h_im-T)/2);        
    case '3'
        edg_x=min_edg_x;
        edg_y=h_im-min_edg_y-T;
    case '4'
        edg_x=ceil((w_im-T)/2);
        edg_y=ceil((h_im-T)/2);
    case '5'
        edg_x=w_im-min_edg_x-T;
        edg_y=min_edg_y;
    case '6'
        edg_x=w_im-min_edg_x-T;
        edg_y=ceil((h_im-T)/2);
    case '7'
        edg_x=w_im-min_edg_x-T;
        edg_y=h_im-min_edg_y-T;
end

pin_y_start=edg_y-t+1;
pin_x_start=edg_x+ceil((T-t)/2)+1;

%design the square
imageUp=zeros(h_im,w_im);
imageUp(edg_y+1:edg_y+T, edg_x+1:edg_x+T)=square_col;
%design the pin
imageUp(pin_y_start:pin_y_start+t, pin_x_start:pin_x_start+t-1)=square_col;

%% rotation
switch direction
    case 'up'
        image=imageUp;
    case 'left'
        image=imrotate(imageUp,90);
    case 'down'
        image=imrotate(imageUp,180);
    case 'right'
        image=imrotate(imageUp, 270);
end

%imshow(image,[0,1]);
%% The filter
hsize = pix;  %only an even number
sigma = hsize^0.5;
h = fspecial('gaussian', hsize, sigma);
%imshow(h,[]);
%% filter by IMFILTER function
blur_im = imfilter(image,h,'replicate');
%imshow(blur_im,[0,1]);

%% sampling of the picture
sample_im=zeros(h_im,w_im);
last_sample=w_im-pix+1;
for i=1:pix:last_sample
    for j=1:pix:last_sample
        sample_im(i:i+pix-1,j:j+pix-1)=blur_im(i+floor(pix/2),j+floor(pix/2));
    end
end
%imshow(sample_im,[0,1]);

%% create phosphenes
pix_no=h_im/pix; %number of phosphenes
Phosphene_Matrix=repmat(h,pix_no,pix_no);
%imshow(Phosphene_Matrix,[]);


phosphene_image=sample_im.*Phosphene_Matrix;
%imshow(phosphene_image,[]);

%% display

subplot(2,2,1);
imshow(image,[0,1]);
title('original image');

subplot(2,2,2);
imshow(blur_im,[0,1]);
title('blur image');

subplot(2,2,3);
imshow(sample_im,[0,1]);
title('sample image');

subplot(2,2,4);
imshow(phosphene_image,[]);
title('phosphene image');