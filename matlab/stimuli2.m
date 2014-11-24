%STIMULI2
clc
clear all
close all

%% Image's parameters
FOV=45;                                 %field of view in degrees
height=900;
width=height;
square_size_deg=10;                     %internal square size in degrees
square_size=square_size_deg/FOV*height; %intenal square size in pixels

%% Contrast parameters
rim_col= [0.1 0.2 0.3 0.4];
square_col= 0.5;

%% Bulge's parameters
bulge_deg=[0.125 0.25 0.5 1 2];         %bulge sizes in degrees
bulge_pix=floor((bulge_deg./FOV)*height);      %bulge sizes in pixels

%% Resolutions parameters
res=[1.25 2.5 10];                      %Desired resolutions in CPD
num_phos_res=res.*2*FOV;                %number of phosphenes in the whole image per resolution 
pix_res=height./num_phos_res;           %number of pixels in one phosphene per resolution          

%% Create the image

edg_x=ceil((width-square_size)/2);
edg_y=ceil((height-square_size)/2);

imgsCount=1;
imgs=[];

for c=1:size(rim_col,2)       %contrast
    imageUp=ones(height,width)*rim_col(c);
    imageUp(edg_y+1:edg_y+square_size, edg_x+1:edg_x+square_size)=square_col;
    
    rimInd=find(imageUp==rim_col(c));
    mask=zeros(height,width);
    mask(rimInd)=1; 
    
    for b=1:size(bulge_deg,2) %bulge
        for r=1:size(res,2)   %resolution
            pix=pix_res(r);
            bulge_xstart=floor(((width-bulge_pix(b))/2)/pix)*pix;
            bulge_ystart=edg_y-bulge_pix(b)+1;
            counter=1;
            imgs_temp=[];
            luminosity=[];
            for shift=0:pix
                %draw the bulge
                imageUp1=imageUp;
                imageUp1(bulge_ystart:edg_y, bulge_xstart+1+shift:bulge_xstart+bulge_pix(b)+shift)=square_col;
                %The filter
                hsize = pix;
                sigma = hsize^0.5;
                h = fspecial('gaussian', hsize, sigma);
                %filter by IMFILTER function
                blur_im = imfilter(imageUp1,h,'replicate');
                %sampling of the picture
                sample_im=zeros(height,width);
                last_sample=width-pix+1;
                for i=1:pix:last_sample
                    for j=1:pix:last_sample
                        sample_im(i:i+pix-1,j:j+pix-1)=blur_im(i+floor(pix/2),j+floor(pix/2));
                    end
                end

                %create phosphenes
                Phosphene_Matrix=repmat(h,ceil(num_phos_res(r)),ceil(num_phos_res(r)));
                Phosphene_Matrix=Phosphene_Matrix(1:height,1:width);
                phosphene_image=sample_im.*Phosphene_Matrix;
                imgs_temp(:,:,counter)=phosphene_image;
                luminosity(counter)=max(max(mask.*phosphene_image))./max(max(phosphene_image));
                counter=counter+1;
            end
            ideal_image=find(luminosity==max(luminosity));
            imgs(:,:,imgsCount)=imgs_temp(:,:,ideal_image(1));
            imgsCount=imgsCount+1;
        end
    end 
    
end

%% Display



