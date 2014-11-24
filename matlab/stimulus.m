function imgs=stimulus
%ONE STIMULUS WITH SPECIFIC PARAMETERS

% screen size and angles
% get screen size
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','centimeters')
CM_SS = get(0,'screensize');
%widthFig=atan(angleFig)*distanceFromScreen;  %cm
%widthFig=round(widthFig/CM_SS(3)*Pix_SS(3)); %pix


angleDim='h'; % 'h' or 'w' determine the 45deg angle by window hight / width
FOV=45;                                 %field of view in degrees
if strcmp(angleDim,'h')
    distanceFromScreen=CM_SS(4)/2/tand(FOV/2);
elseif strcmp(angleDim,'w')
    distanceFromScreen=CM_SS(3)/2/tand(FOV/2);
else
    error('choose dimention for figure limits')
end
uiwait(msgbox(['Please sit ',num2str(round(distanceFromScreen)),'cm From screen']));


%figure('Units','pixels','Position',[100 100 n m])
% set(gca,'Position',[0 0 1 1])
%% Image's parameters (phosphene area)
heightDeg=10;
heightPix=round(Pix_SS(4)*heightDeg/FOV);
%height=900;
widthPix=heightPix;
square_size_deg=5;                     %internal square size in degrees
square_size=round(square_size_deg/FOV*heightPix); %intenal square size in pixels

%% Contrast parameters
rim_col= 0.2;
square_col= 0.6;

%% Bulge's parameters
bulge_deg=0.5;                        %bulge sizes in degrees
bulge_pix=round((bulge_deg./FOV)*heightPix);      %bulge sizes in pixels

%% Resolutions parameters
res=0.5;                                %Desired resolutions in CPD
num_phos_res=res.*2*FOV;                %number of phosphenes in the whole image per resolution 
pix_res=round(heightPix./num_phos_res);           %number of pixels in one phosphene per resolution          

%% Create the image

edg_x=ceil((widthPix-square_size)/2);
edg_y=ceil((heightPix-square_size)/2);


imageUp=ones(heightPix,widthPix)*rim_col;
imageUp(edg_y+1:edg_y+square_size, edg_x+1:edg_x+square_size)=square_col;

rimInd=find(imageUp==rim_col);
mask=zeros(heightPix,widthPix);
mask(rimInd)=1; 
    
bulge_xstart=floor(((widthPix-bulge_pix)/2)/pix_res)*pix_res;
bulge_ystart=round(edg_y-bulge_pix+1);
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
    sample_im=zeros(heightPix,widthPix);
    last_sample=widthPix-pix_res+1;
    for i=1:pix_res:last_sample
        for j=1:pix_res:last_sample
            sample_im(i:i+pix_res-1,j:j+pix_res-1)=blur_im(i+floor(pix_res/2),j+floor(pix_res/2));
        end
    end
    
%     for i=1:pix_res:last_sample
%         for j=1:pix_res:last_sample
%             sample_im(i:i+pix_res-1,j:j+pix_res-1)=imageUp1(i+floor(pix_res/2),j+floor(pix_res/2));
%         end
%     end
%     
    %sample_im=imageUp1;
    %create phosphenes
    Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
    if length(Phosphene_Matrix)<length(sample_im)
        del=round((length(sample_im)-length(Phosphene_Matrix))/2);
        sample_im=sample_im(del+1:end,del+1:end);
        del=length(sample_im)-length(Phosphene_Matrix);
        sample_im=sample_im(1:end-del,1:end-del);
        mask1=mask
    elseif length(Phosphene_Matrix)>length(sample_im)
        temp=sample_im(1)*ones(size(Phosphene_Matrix));
        temp1=mask(1)*ones(size(Phosphene_Matrix));
        del=round((length(Phosphene_Matrix)-length(sample_im))/2);
        temp(del+1:del+length(sample_im),del+1:del+length(sample_im))=sample_im;
        temp1(del+1:del+length(sample_im),del+1:del+length(sample_im))=mask;
        sample_im=temp;
        mask1=temp1;
    end
    phosphene_image=sample_im.*Phosphene_Matrix;
    imgs_temp(:,:,counter)=phosphene_image;
    luminosity(counter)=max(max(mask1.*phosphene_image))./max(max(phosphene_image));
    counter=counter+1;
end
ideal_image=find(luminosity==max(luminosity));
imgs=imgs_temp(:,:,ideal_image(1));



%% Display

figure;imshow(imgs,[]);
figure;imagesc(imgs);colormap('gray')




