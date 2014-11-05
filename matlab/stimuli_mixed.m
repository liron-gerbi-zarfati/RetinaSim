function [imgs,stimType]=stimuli_mixed
%% The square's parameters
% run : 
% [imgs,stimType]=stimuli_mixed;
% experiment1(imgs,stimType)

pix=16;   %number of pixels in one phosphene
h_im=400; %the height of the image
w_im=400; %the width of the image
T=150;    %the width of the rectangle - max value is 200

rim=40;
T_rim=T+2*rim;
edg_x=ceil((w_im-T_rim)/2);
edg_y=ceil((h_im-T_rim)/2);



rim_col=0.25;
square_col=0.5;

imgs=[];
imgsCount=1;

%design the square
imageUp=zeros(h_im,w_im);
imageUp(edg_y+1:edg_y+2*rim+T, edg_x+1:edg_x+2*rim+T)=rim_col;
imageUp(edg_y+rim+1:edg_y+rim+T, edg_x+rim+1:edg_x+rim+T)=square_col;
rimInd=find(imageUp==0.25);
mask=zeros(400,400);
mask(rimInd)=1;
for chupSize=[0 8:4:20]
    t=chupSize;
    pin_y_start=edg_y+rim-t+1;
    pin_x_start=192;
    %design the pin
    for shift=-15:15
        imageUp1=imageUp;
        imageUp1(pin_y_start:pin_y_start+t, pin_x_start+shift:pin_x_start+shift+t-1)=square_col;
        
        %create the directions
        dir1=imageUp1;%up
        dir2=imrotate(imageUp1,90);%left
        dir3=imrotate(imageUp1,180);%down
        dir4=imrotate(imageUp1, 270);%right
        for directioni=1:4
            if t==0 && directioni>1
                % do not build too many catch trials
            else
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
                imgs(:,:,imgsCount)=phosphene_image;
                stimType(imgsCount,1:4)=[t,shift,max(max(mask.*phosphene_image))./max(max(phosphene_image)),directioni]; %  chupchik size, shift, luminosity, direction
                if rim==0 && t==0
                    stimType(imgsCount,5)=0;
                end
                imgsCount=imgsCount+1;
            end
        end
    end
end
%save imgs imgs stimType
end


