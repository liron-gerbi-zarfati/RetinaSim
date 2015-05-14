function [] = expRead3(CPD)
% Log,resampVec,limits
if ~exist('CPD','var')
    CPD=[];
end
if isempty(CPD)
    CPD=2;
end
grayColors=4; % how many shades of gray
msg=1;
%% make phosphene matrix
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','centimeters');
CM_SS = get(0,'screensize');
txt=rgb2gray(imread(('~/RetinaSim/Hen/alice100.png')));
[N,M]=size(txt);
% minColor=0; maxColor=1;
% imagesc(txt, [minColor maxColor]);
% set(gca,'xtick',[])
% set(gca,'ytick',[])
% colormap('gray');

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
sigma = pix_res/4;
h = fspecial('gaussian', pix_res, sigma);
h=h-min(min(h));
h=h./max(max(h));
Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
[S,L]=size(Phosphene_Matrix);
%% make shape
% txt=rgb2gray(imread(('alice100.png')));
% [N,L]=size(txt);
% Phosphene_Matrix=repmat(h,N,L);

txt=imread('~/RetinaSim/Hen/Arro.png');
phosInd=zeros(S,L);
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

% x0=720;
% y0=90;
pix=length(phosInd)/2;
background=zeros(size(txt));
img_temp=background;
% img_temp=Phosphane_the_image(txt,pix_res,h);
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
% if yinit+pix>Pix_SS(4)
%     yinit=size(txt,1)-pix;
% end
matData=txt(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1);
% matData=txt;
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
% img_temp(Center_in_Pix(1,2)-S/2:Center_in_Pix(1,2)+S/2-1,Center_in_Pix(1,1)-L/2:Center_in_Pix(1,1)+L/2-1)=Phosphane_the_image(matData,pix_res,h);

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
pixStartY=max(1,round(Pix_SS(4)/2-size(background,1)/2));
% pixStartY=round(Pix_SS(4)/2-size(background,1)/2);

% set(gca,'Units','pixels','Position',[pixStartX pixStartY size(background,2) size(background,1)])
set(gca,'Units','pixels','Position',[pixStartX pixStartY size(background,2) size(background,1)])
global r;
r=0;
global zoom_flag;
zoom_flag=0;
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
% img_temp=Phosphane_the_image(txt,pix_res,h);
uiwait(fh);
%% callback functions

% global xinit_txt_last;
% global yinit_txt_last;
% global pix_del_x;
% pix_del_x=initx;

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
            global Zoom_factor;
            global k;  
            k=0;
            zoom_flag=1;
            xinit_txt_last=xinit;
            yinit_txt_last=yinit;
            if event.VerticalScrollCount < 0 %up 
%                 pix_del_x=floor(1.5*xinit);
%                 pix_del_y=floor(1.5*yinit);
                Zoom_factor=1.5;
                txt=imresize(txt,1.5);  
                Log(end+1,:)=[toc,3,xinit,yinit,pix];               
                r=r+1;
            elseif event.VerticalScrollCount > 0 %down               
%                 pix_del_x=floor(2/3*xinit);
%                 pix_del_y=floor(2/3*yinit);
                Zoom_factor=2/3;
                txt=imresize(txt,2/3);  
                if(size(txt,1))==N;
                    zoom_flag=0;
                end
                Log(end+1,:)=[toc,4,xinit,yinit,pix];
            end            
            plotSquare(xinit,yinit,pix,minColor,maxColor,src)
        end
    end
%% functions

    function []=plotSquare(xinit,yinit,pix,minColor,maxColor,~)
        %         global zoom_flag;
        global Zoom_factor;
        %         global xinit_txt_last;
        %         global pix_del_x;
        global k;
        if xinit-pix<1
            xinit=pix+1;
            if size(background,2)<size(txt,2)
                xinit_txt=max(xinit-k*10,pix+1);
                k=k+1;
            end
        end
        if yinit-pix<1
            yinit=pix+1;
            if size(background,1)<size(txt,1)
                yinit_txt=max(yinit-k*10,pix+1);
                k=k+1;
            end
        end
        
        %         if xinit+pix>size(background,2)
        %            xinit=size(background,2)-pix;
        %            xinit_txt=xinit;
        %            if zoom_flag
        %                xinit_txt=min(pix_del_x,size(txt,1)-pix);
        %            end
        %         end
        
        
        % % % % % % % % % % % % % % % % % % % % % % %
        if xinit+pix>size(background,2)
            xinit=size(background,2)-pix;
% % % % % % % % % %             if zoom_flag %meaning I'm in zoom mode
% % % % % % % % % %                 xinit_txt=floor(xinit*r*Zoom_factor);
% % % % % % % % % %                 xinit_txt_last=xinit_txt;
% % % % % % % % % %                 if xinit_txt < xinit_txt_last
% % % % % % % % % %                     xinit_txt=max(xinit_txt-k*10,1);
% % % % % % % % % %                     k=k-1;
% % % % % % % % % %                 elseif xinit_txt >= xinit_txt_last
% % % % % % % % % %                     xinit_txt=min(xinit_txt+k*10,size(txt,2)-pix);
% % % % % % % % % %                     k=k+1;
% % % % % % % % % %                 end
% % % % % % % % % %             else %not in zoom mode
% % % % % % % % % %                 xinit_txt=xinit;
% % % % % % % % % %             end
        else
% % % % % % % % % %             if zoom_flag
% % % % % % % % % %                 xinit_txt=min(floor(xinit*r*Zoom_factor)-pix,size(txt,2)-pix);
% % % % % % % % % %                 %             if  xinit_txt < xinit_txt_last
% % % % % % % % % %                 %                 xinit_txt_last=xinit_txt;
% % % % % % % % % %                 %  				xinit_txt=max(xinit_txt-k*10,1);
% % % % % % % % % %                 %                 k=k-1;
% % % % % % % % % %                 %             elseif xinit_txt >= xinit_txt_last
% % % % % % % % % %                 % 				xinit_txt_last=xinit_txt;
% % % % % % % % % %                 % 				xinit_txt=min(xinit_txt+k*10,size(txt,2)-pix);
% % % % % % % % % %                 %                 k=k+1;
% % % % % % % % % %             else
% % % % % % % % % %             end
        end
        
        % % % % % % % % % % % % % % % % % %
        if yinit+pix>size(background,1)
            yinit=size(background,1)-pix;
            %             if size(background,1)<size(txt,1)
            %                 yinit_txt=min(yinit+k*10,size(txt,1)-pix);
            %                 k=k+1;
            %             end
        end
        yinit_txt=yinit*1.5^r;
        xinit_txt=xinit*1.5^r;

        %try
        matData=txt(yinit_txt-pix:yinit_txt+pix-1,xinit_txt-pix:xinit_txt+pix-1);
        %         catch
        %             err1=yinit_txt-pix
        %             err2=yinit_txt+pix-1
        %             err3=xinit_txt-pix
        %             err4=xinit_txt+pix-1
        %             size(txt)
        %         end
        %         matData=txt(yinit-pix:yinit+pix-1,xinit-pix:xinit+pix-1);
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
        
        %         img_temp(Center_in_Pix(1,2)-S/2:Center_in_Pix(1,2)+S/2-1,Center_in_Pix(1,1)-L/2:Center_in_Pix(1,1)+L/2-1)=Phosphane_the_image(matData,pix_res,h);
        imagesc(img_temp,[minColor maxColor])
        %image(img_temp)
        % axis off
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        colormap('gray');
        img_temp=background;%uint8(zeros(size(img)));
        %         img_temp=Phosphane_the_image(txt,pix_res,h);
    end
end