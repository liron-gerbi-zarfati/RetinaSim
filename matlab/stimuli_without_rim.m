function stimuli_without_rim
clc
clear all
close all
%% The square's parameters
pix=16;   %number of pixels in one phosphene
h_im=400; %the height of the image
w_im=400; %the width of the image
T=150;    %the width of the rectangle - max value is 200
t=16;     %the width of the small rect
min_edg_x=30;
min_edg_y=30;
square_col=0.5;
imgs=[];

for p=1:7
    position=num2str(p);
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
    
    %create the directions
    dir1=imageUp;%up
    dir2=imrotate(imageUp,90);%left
    dir3=imrotate(imageUp,180);%down
    dir4=imrotate(imageUp, 270);%right
    for directioni=1:4
        eval(['imgCurrent=dir',num2str(directioni),';']);
        %% The filter
        hsize = pix;  
        sigma = hsize^0.5;
        h = fspecial('gaussian', hsize, sigma);
      
        %% filter by IMFILTER function
        blur_im = imfilter(imgCurrent,h,'replicate');
        
        %% sampling of the picture
        sample_im=zeros(h_im,w_im);
        last_sample=w_im-pix+1;
        for i=1:pix:last_sample
            for j=1:pix:last_sample
                sample_im(i:i+pix-1,j:j+pix-1)=blur_im(i+floor(pix/2),j+floor(pix/2));
            end
        end

        %% create phosphenes
        pix_no=h_im/pix; %number of phosphenes
        Phosphene_Matrix=repmat(h,pix_no,pix_no);
        
        phosphene_image=sample_im.*Phosphene_Matrix;
        imgs(:,:,end+1)=phosphene_image;
    end
end
experiment(imgs)
end


