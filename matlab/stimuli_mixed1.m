function [imgs,stimType]=stimuli_mixed1
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


rim_col=[0.1 0.2 0.3 0.4];
square_col=0.5;

imgsCount=1;
imgs=[];


for colour=1:length(rim_col)
    
    %design the square for a particular contrast
    imageUp=zeros(h_im,w_im);
    imageUp(edg_y+1:edg_y+2*rim+T, edg_x+1:edg_x+2*rim+T)=rim_col(colour);
    imageUp(edg_y+rim+1:edg_y+rim+T, edg_x+rim+1:edg_x+rim+T)=square_col;
    
    rimInd=find(imageUp==rim_col(colour));
    mask=zeros(400,400);
    mask(rimInd)=1; %#ok<*FNDSB>
    
    for chupSize=[8:4:20]
        t=chupSize;
        pin_y_start=edg_y+rim-t+1;
        pin_x_start=192;    %where there is a start of a new phosphene
        counter=1;
        imgs_temp=[];
        luminosity=[];
        %design the pin
        for shift=-5:10
            imageUp1=imageUp;
            imageUp1(pin_y_start:pin_y_start+t, pin_x_start+shift:pin_x_start+shift+t-1)=square_col;

            %% The filter
            hsize = pix;
            sigma = hsize^0.5;
            h = fspecial('gaussian', hsize, sigma);

            %% filter by IMFILTER function
            blur_im = imfilter(imageUp1,h,'replicate');

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
            imgs_temp(:,:,counter)=phosphene_image;
            luminosity(counter)=max(max(mask.*phosphene_image))./max(max(phosphene_image));
            counter=counter+1;
        end
        ideal_image=find(luminosity==max(luminosity));
        imgs(:,:,imgsCount)=imgs_temp(:,:,ideal_image(1));
        stimType(imgsCount,1:4)=[t,0,rim_col(colour),1]; %  chupchik size, shift, luminosity, direction
   
        imgsCount=imgsCount+1;
    end
end
% end
    
    imgs1=imgs(:,:,[2:4:16]);
    stimType1=stimType([2:4:16],:);
    stimType=[];
    imgs=[];
    imgsCount=0;
    for lumi=1:4
        for diri=1:4
            imgsCount=imgsCount+1;
            imgs(1:400,1:400,imgsCount)=imrotate(imgs1(:,:,lumi),90*(diri-1));
            stimType(imgsCount,1:4)=stimType1(lumi,:);
            stimType(imgsCount,4)=diri;
        end
    end
            
            
%             dir1=imageUp1;%#ok<*NASGU> %up
%         dir2=imrotate(imageUp1,90);%left
%         dir3=imrotate(imageUp1,180);%down
%         dir4=imrotate(imageUp1, 270);%right
%             
            
            
            
            
            
            
            
            

