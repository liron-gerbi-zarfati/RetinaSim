function stimuli
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

imageUp=zeros(h_im,w_im);
imageUp(edg+1:edg+T, edg+1:edg+T)=0.5;
imageUp(edg-t+1:edg,((w_im-t)/2+1):((w_im-t)/2+t))=0.5;
dir1=imageUp;%up
dir2=imrotate(imageUp,90);%left
dir3=imrotate(imageUp,180);%down
dir4=imrotate(imageUp, 270);%right
for directioni=1:4
    eval(['imgCurrent=dir',num2str(directioni),';']);
    %imshow(imageUp,[0,1]);
    %% The filter
    hsize = pix;  %only an even number
    sigma = hsize^0.5;
    h = fspecial('gaussian', hsize, sigma);
    %imshow(h,[]);
    %% filter by IMFILTER function
    blur_im = imfilter(imgCurrent,h,'replicate');
    %imshow(blur_im,[0,1]);
    
    %% sampling of the picture
    sample_im=zeros(h_im,w_im);
    last_sample=h_im-16+1;
    for i=1:pix:last_sample
        for j=1:pix:last_sample
            sample_im(i:i+pix-1,j:j+pix-1)=blur_im(i+pix-1,j+pix-1);
        end
    end
    %imshow(sample_im,[]);
    
    %% create phosphenes
    pix_no=h_im/pix; %number of phosphenes
    Phosphene_Matrix=repmat(h,pix_no,pix_no);
    %imshow(Phosphene_Matrix,[]);
    phosphene_image=sample_im.*Phosphene_Matrix;
    %imshow(phosphene_image,[]);
    %eval(['img',num2str(directioni),'=phosphene_image;']);
    if directioni==1
        imgs=phosphene_image;
    else
        imgs(:,:,directioni)=phosphene_image;
    end
end
experiment(imgs)
