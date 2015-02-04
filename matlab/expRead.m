function expRead(CPD)
if ~exist('CPD','var')
    CPD=[];
end
if isempty(CPD)
    CPD=2;
end
grayColors=4; % how many shades of gray
msg=1;
%% make phosphene matrix
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
if msg
    uiwait(msgbox(['Please sit ',num2str(round(distanceFromScreen)),'cm From screen']));
end
%% Resolutions parameters
res=CPD;                                        %Desired resolutions in CPD (2.14 CPD is 42.88*42.88 phosphenes. we want CPD 1.25, 2.5 10)
num_phos_res=round(res.*2*heightDeg);                %number of phosphenes in the whole image per resolution
pix_res=round(heightPix./num_phos_res);           % width of a phosphene in pixels
sigma = pix_res^0.5;
h = fspecial('gaussian', pix_res, sigma);
h=h-min(min(h));
h=h./max(max(h));
Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);

%% make shape
txt=rgb2gray(imread('~/RetinaSim/images/alice100.png'));
phosInd=zeros(size(Phosphene_Matrix));
ind=0;
for i=1:num_phos_res
    for j=1:num_phos_res
        ind=ind+1;
        for I=1:pix_res
            for J=1:pix_res
                phosInd((i-1)*pix_res+I,(j-1)*pix_res+J)=ind;
            end
        end
    end
end

%% make first image and run experiment

minColor=0; % color limits
maxColor=1;

x0=720;
y0=90;
pix=length(phosInd)/2;
background=zeros(size(txt));
img_temp=background;
firstClick=true;
LogN=1; % file number to save, 1 for Log1.mat
% declare global variables to use in functions
Log=[];


matSamples=find(phosInd==1);
for phosi=2:phosInd(end)
    matSamples(:,phosi)=find(phosInd==phosi); % every column has the indices of one gausian in the real image
end

%% resample picture
xinit=Pix_SS(3);
yinit=1;
if xinit-pix<1
    xinit=pix+1;
end
if yinit-pix<1
    yinit=pix+1;
end
if xinit+pix>size(background,2)
    xinit=size(background,2)-pix;
end
if yinit+pix>size(background,1)
    yinit=size(background,1)-pix;
end
matData=txt(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1);
resampVec=mean(matData(matSamples));
resampVec1=zeros(size(resampVec));
limits=min(resampVec):(max(resampVec)-min(resampVec))/grayColors: max(resampVec);
for i=1:grayColors
    greater=resampVec>=limits(i);
    smaller=resampVec<=limits(i+1);
    category=greater+smaller>1;
    resampVec1(category)=(i-1)/(grayColors-1); % for 4 colors you get [0 0.333 0.667 1]
end
resampSquare=zeros(size(matData));
resampSquare(1:end)=resampVec1(phosInd);
img_temp(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1)=resampSquare.*Phosphene_Matrix;

%% display first image and start experiment
startTime='no click yet';
labels={'time(s) from first click','action','x','y','half square'};
actions={'click';'drag';'wheel up (zoom out)';'wheel down (zoom in)';'up';'down';'left';'right';'quit'};
%fh= figure('units','normalized','outerposition',[0 0 1 1],'toolbar','none','MenuBar','none');
%fh= figure('outerposition',[x0 y0 size(background,2)*imgSize size(background,1)*imgSize],'toolbar','none','MenuBar','none');
fh=figure('Units','pixels','Position',Pix_SS,'toolbar','none','MenuBar','none');
%ha = axes('Xlim', [1 size(background,2)],'Ylim',[1 size(background,2)],'XTick',[],'YTick',[]);
ha = axes('XTick',[],'YTick',[]);
pixStartX=round(Pix_SS(3)/2-size(background,2)/2);
pixStartY=round(Pix_SS(4)/2-size(background,1)/2);
set(gca,'Units','pixels','Position',[pixStartX pixStartY size(background,2) size(background,1)])
set(gcf,'Color',[0 0 0]);
set(gca,'color','k')
%set(gcf,'color',[0.1 0.1 0.1])
set(fh,'WindowButtonDownFcn',@Mouse_Press);
set(fh,'WindowKeyPressFcn',@Key_Press);
%image(background)


imagesc(img_temp,[minColor maxColor])
%image(img_temp)
% axis off
set(gca,'xtick',[])
set(gca,'ytick',[])
colormap('gray');
img_temp=background;
uiwait(fh);
%% callback functions
    function Key_Press(~,keyData)
        switch keyData.Key
            case 'q'
                Log(end+1,:)=[toc,9,xinit,yinit,pix];
            case 'uparrow'
                Log(end+1,:)=[toc,5,xinit,yinit,pix];
            case 'downarrow'
                Log(end+1,:)=[toc,6,xinit,yinit,pix];
            case 'leftarrow'
                Log(end+1,:)=[toc,7,xinit,yinit,pix];
            case 'rightarrow'
                Log(end+1,:)=[toc,8,xinit,yinit,pix];
        end
        while exist(['./Log',num2str(LogN),'.mat'],'file')
            LogN=LogN+1;
        end
        save (['Log',num2str(LogN)],'Log','actions','labels','startTime')
        close
        return
    end
    function Mouse_Press(src,~)
        %set(src,'pointer','crosshair')
        cp = get(ha,'CurrentPoint');
        xinit = round(cp(1,1));
        yinit = round(cp(1,2));
        if firstClick
            tic
            startTime=datestr(now);
            firstClick=false;
            Log=[0,1,xinit,yinit,1001]; % time,action,x,y,pix
        else
            Log(end+1,:)=[toc,1,xinit,yinit,pix];
        end
        %       hl = line('XData',xinit,'YData',yinit,...
        %              'color','k','linewidth',2);
        plotSquare(xinit,yinit,pix,minColor,maxColor,src)
        set(src,'WindowButtonMotionFcn',@movedraw)
        set(src,'WindowButtonUpFcn',@enddraw)
        set(src,'WindowScrollWheelFcn',@zoom)
        function movedraw(~,~)
            cp = get(ha,'CurrentPoint');
            xinit = round(cp(1,1));
            yinit = round(cp(1,2));
            Log(end+1,:)=[toc,2,xinit,yinit,pix];
            plotSquare(xinit,yinit,pix,minColor,maxColor,src)
            %               drawnow
        end
        function enddraw(src,~)
            set(src,'Pointer','arrow')
            set(src,'WindowButtonMotionFcn',[])
            set(src,'WindowButtonUpFcn',[])
            uiresume(fh);
        end
        function zoom(~,event)
            if event.VerticalScrollCount < 0 %up
                Log(end+1,:)=[toc,3,xinit,yinit,pix];
%                 if pix<maxPix
%                     pix=pix+5;
%                     Log(end,5)=pix;
%                 end
            elseif event.VerticalScrollCount > 0 %down
                Log(end+1,:)=[toc,4,xinit,yinit,pix];
%                 if pix>minPix
%                     pix=pix-5;
%                     Log(end,5)=pix;
%                 end
            end
            plotSquare(xinit,yinit,pix,minColor,maxColor,src)
        end
    end
%% functions
    function plotSquare(xinit,yinit,pix,minColor,maxColor,src)
        if xinit-pix<1
            xinit=pix+1;
        end
        if yinit-pix<1
            yinit=pix+1;
        end
        if xinit+pix>size(background,2)
            xinit=size(background,2)-pix;
        end
        if yinit+pix>size(background,1)
            yinit=size(background,1)-pix;
        end
        matData=txt(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1);
        resampVec=mean(matData(matSamples));
        resampVec1=zeros(size(resampVec));
        limits=min(resampVec):(max(resampVec)-min(resampVec))/grayColors: max(resampVec);
        for i=1:grayColors
            greater=resampVec>=limits(i);
            smaller=resampVec<=limits(i+1);
            category=greater+smaller>1;
            resampVec1(category)=(i-1)/(grayColors-1); % for 4 colors you get [0 0.333 0.667 1]
        end
        resampSquare=zeros(size(matData));
        resampSquare(1:end)=resampVec1(phosInd);
        img_temp(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1)=resampSquare.*Phosphene_Matrix;
        imagesc(img_temp,[minColor maxColor])
        %image(img_temp)
        % axis off
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        colormap('gray');
        img_temp=background;%uint8(zeros(size(img)));
    end
end
