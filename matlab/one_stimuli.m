function imgs=one_stimuli

%ONE STIMULI WITH SPECIFIC PARAMETERS
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
rim_col= 0.2;
square_col= 0.1;

%% Bulge's parameters
bulge_deg=0.5;                        %bulge sizes in degrees
bulge_pix=(bulge_deg./FOV)*height;      %bulge sizes in pixels

%% Resolutions parameters
res=0.5;                                %Desired resolutions in CPD
num_phos_res=res.*2*FOV;                %number of phosphenes in the whole image per resolution 
pix_res=height./num_phos_res;           %number of pixels in one phosphene per resolution          

%% Create the image

edg_x=ceil((width-square_size)/2);
edg_y=ceil((height-square_size)/2);


imageUp=ones(height,width)*rim_col;
imageUp(edg_y+1:edg_y+square_size, edg_x+1:edg_x+square_size)=square_col;

rimInd=find(imageUp==rim_col);
mask=zeros(height,width);
mask(rimInd)=1; 
    
bulge_xstart=floor(((width-bulge_pix)/2)/pix_res)*pix_res;
bulge_ystart=edg_y-bulge_pix+1;
counter=1;
imgs_temp=[];
luminosity=[];
for shift=0:pix_res
    %draw the bulge
    imageUp1=imageUp;
    imageUp1(bulge_ystart:edg_y, bulge_xstart+1+shift:bulge_xstart+bulge_pix+shift)=square_col;
    %The filter
    hsize = pix_res;
    sigma = hsize^0.5;
    h = fspecial('gaussian', hsize, sigma);
    %filter by IMFILTER function
    blur_im = imfilter(imageUp1,h,'replicate');
    %sampling of the picture
    sample_im=zeros(height,width);
    last_sample=width-pix_res+1;
    for i=1:pix_res:last_sample
        for j=1:pix_res:last_sample
            sample_im(i:i+pix_res-1,j:j+pix_res-1)=blur_im(i+floor(pix_res/2),j+floor(pix_res/2));
        end
    end

    %create phosphenes
    Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
    phosphene_image=sample_im.*Phosphene_Matrix;
    imgs_temp(:,:,counter)=phosphene_image;
    luminosity(counter)=max(max(mask.*phosphene_image))./max(max(phosphene_image));
    counter=counter+1;
end
ideal_image=find(luminosity==max(luminosity));
imgs=imgs_temp(:,:,ideal_image(1));



%% Display

figure;imshow(imgs,[]);
figure;imagesc(imgs);colormap('gray')




