function testSigma1(CPD,bulge_deg,fac)
if ~exist('CPD','var')
    CPD=[];
end
if isempty(CPD)
    CPD=2.14;
end
if ~exist('bulge_deg','var')
    bulge_deg=[];
end
if isempty(bulge_deg)
    bulge_deg=0.5;
end
if ~exist('sig','var')
    sig=[];
end
if isempty(sig)
    sig=0.5;
end
trialLim=3; % max trial length (seconds)
rim_col= 1/1.5; % 0.6667 background is 50% Webber contrast for 1 figure

step1=0.25;% in dB
step2=0.1;
step=1/10.^(step1/10); % dB to ratio

detections=1;

square_col= 1;
msg= true;
jitter=[600 800];


%% make phosphene matrix
maxTrials=3000;
% screen size and angles
% get screen size
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','centimeters')
CM_SS = get(0,'screensize');



angleDim='w'; % 'h' or 'w' determine the 45deg angle by window hight / width
FOV=45;
heightDeg=10;%field of view in degrees
% compute the aray hight(=width) of phosphenes in pixels
if strcmp(angleDim,'h')
    distanceFromScreen=CM_SS(4)/2/tand(FOV/2);
    heightPix=round(Pix_SS(4)*heightDeg/FOV);
elseif strcmp(angleDim,'w')
    distanceFromScreen=CM_SS(3)/2/tand(FOV/2);
    heightPix=round(Pix_SS(3)*heightDeg/FOV);
else
    error('choose dimention for figure limits')
end



%figure('Units','pixels','Position',[100 100 n m])
% set(gca,'Position',[0 0 1 1])
%% Image's parameters (phosphene area)


%height=900;
%widthPix=heightPix;
square_size_deg=5;                     %internal square size in degrees
square_size=round(square_size_deg/heightDeg*heightPix); %intenal square size in pixels

%% Bulge's parameters
%bulge sizes in degrees
bulge_pix=round((bulge_deg./FOV)*heightPix);      %bulge sizes in pixels

%% Resolutions parameters
res=CPD;                                        %Desired resolutions in CPD (2.14 CPD is 42.88*42.88 phosphenes. we want CPD 1.25, 2.5 10)
num_phos_res=round(res.*2*heightDeg);                %number of phosphenes in the whole image per resolution
pix_res=round(heightPix./num_phos_res);           % width of a phosphene in pixels
sigma = pix_res/fac;%sig;
h = fspecial('gaussian', pix_res, sigma);
h=h-min(min(h));
h=h./max(max(h));
Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
% mid=nearest(h(round(length(h)./2),:),0.5);
% mid=min(mid,length(h)-mid+1);
% midRatio=mid/length(h);

figure('position',[100,100,500,500]);
colormap gray
imagesc(Phosphene_Matrix);
title(['sigma = length / ',num2str(fac),')'])