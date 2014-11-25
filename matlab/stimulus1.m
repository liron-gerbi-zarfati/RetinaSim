function Phosphene_Matrix=stimulus1
%ONE STIMULUS WITH SPECIFIC PARAMETERS

% screen size and angles
% get screen size
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','centimeters')
CM_SS = get(0,'screensize');
%widthFig=atan(angleFig)*distanceFromScreen;  %cm
%widthFig=round(widthFig/CM_SS(3)*Pix_SS(3)); %pix


angleDim='w'; % 'h' or 'w' determine the 45deg angle by window hight / width
FOV=45;
heightDeg=10;%field of view in degrees
if strcmp(angleDim,'h')
    distanceFromScreen=CM_SS(4)/2/tand(FOV/2);
    heightPix=round(Pix_SS(4)*heightDeg/FOV);
elseif strcmp(angleDim,'w')
    distanceFromScreen=CM_SS(3)/2/tand(FOV/2);
    heightPix=round(Pix_SS(3)*heightDeg/FOV);
else
    error('choose dimention for figure limits')
end
%uiwait(msgbox(['Please sit ',num2str(round(distanceFromScreen)),'cm From screen']));


%figure('Units','pixels','Position',[100 100 n m])
% set(gca,'Position',[0 0 1 1])
%% Image's parameters (phosphene area)


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
res=2.14;                                        %Desired resolutions in CPD (2.14 CPD is 42.88*42.88 phosphenes. we want CPD 1.25, 2.5 10)
num_phos_res=round(res.*2*heightDeg);                %number of phosphenes in the whole image per resolution 
pix_res=round(heightPix./num_phos_res);           % width of a phosphene in pixels          
hsize = pix_res;
sigma = hsize^0.5;
h = fspecial('gaussian', hsize, sigma);
h=h-min(min(h));
h=h./max(max(h));
Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
%figure;
pixStartX=round(Pix_SS(3)/2-length(Phosphene_Matrix)/2);
pixStartY=round(Pix_SS(4)/2-length(Phosphene_Matrix)/2);
figure('Units','pixels','Position',Pix_SS,'toolbar','none','MenuBar','none')
imagesc(Phosphene_Matrix);colormap gray 
set(gca,'Units','pixels','Position',[pixStartX pixStartY length(Phosphene_Matrix) length(Phosphene_Matrix)])
pause
close