function  startdraw1
pat=which('startdraw1');
pat=pat(1:end-19)
cd(pat);

% FIXME set(gca, 'Position', get(gca, 'OuterPosition') - ...
%     get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
%% set some parameters
pix=30; % half of the square in pixels
winSizeStep=5;
% color scale
minColor=0; 
maxColor=255;
% when to ignore wheel (too large or too small window size)
maxWin=2000; 
minWin=100;
% where to put image
x0=200;
y0=100;
% image size factor
imgSize=1;
gray=false;
%% load image
if gray
    img=rgb2gray(imread('peppers.png'));
    img(:,:,2)=img;img(:,:,3)=img(:,:,1);
else
    img=imread('peppers.png');
end
arrows=imread('images/4arrows.png');
background=uint8(zeros(size(img)));
background(:,end+1:end+145,:)=arrows;
winSize=imgSize*[size(background,1) size(background,2)];
%% run the experiment
img_temp=background;
firstClick=true;
logN=1; % file number to save, 1 for log1.mat
% declare global variables to use in functions
log=[];
xinit=1;
yinit=1;
pos=[x0 y0 size(background,2)*imgSize+x0 size(background,1)*imgSize+y0];
startTime='no click yet';
labels={'time(s) from first click','action','x','y','half square'};
actions={'click';'drag';'wheel up (zoom out)';'wheel down (zoom in)';'up';'down';'left';'right';'quit'};
%fh= figure('units','normalized','outerposition',[0 0 1 1],'toolbar','none','MenuBar','none');
fh= figure('position',pos,'toolbar','none','MenuBar','none');
ha = axes('Xlim', [1 size(img,2)],'Ylim',[1 size(img,2)],'XTick',[],'YTick',[]);
set(gca,'color','k')
set(gcf,'color',[0.1 0.1 0.1])
set(fh,'WindowButtonDownFcn',@Mouse_Press);
set(fh,'WindowKeyPressFcn',@Key_Press);
image(background)
set(gca,'xtick',[],'ytick',[])
uiwait(fh);
%% callback functions
    function Key_Press(~,keyData)
        switch keyData.Key
            case 'q'
                log(end+1,:)=[toc,9,xinit,yinit,winSize(1),winSize(2)];
            case 'uparrow'
                log(end+1,:)=[toc,5,xinit,yinit,winSize(1),winSize(2)];
            case 'downarrow'
                log(end+1,:)=[toc,6,xinit,yinit,winSize(1),winSize(2)];
            case 'leftarrow'
                log(end+1,:)=[toc,7,xinit,yinit,winSize(1),winSize(2)];
            case 'rightarrow'
                log(end+1,:)=[toc,8,xinit,yinit,winSize(1),winSize(2)];
        end
        while exist(['./log',num2str(logN),'.mat'],'file')
            logN=logN+1;
        end
        save (['log',num2str(logN)],'log','actions','labels','startTime')
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
            log=[0,1,xinit,yinit,winSize(1),winSize(2)]; % time,action,x,y,pix
        else
            log(end+1,:)=[toc,1,xinit,yinit,winSize(1),winSize(2)];
        end
        %       hl = line('XData',xinit,'YData',yinit,...
        %              'color','k','linewidth',2);
        plotSquare(xinit,yinit,pix,pos,src)
        set(src,'WindowButtonMotionFcn',@movedraw)
        set(src,'WindowButtonUpFcn',@enddraw)
        set(src,'WindowScrollWheelFcn',@zoom)
        function movedraw(~,~)
            cp = get(ha,'CurrentPoint');
            xinit = round(cp(1,1));
            yinit = round(cp(1,2));
            log(end+1,:)=[toc,2,xinit,yinit,winSize(1),winSize(2)];
            plotSquare(xinit,yinit,pix,pos,src)
            %               drawnow
        end
        function enddraw(src,~)
            set(src,'Pointer','arrow')
            set(src,'WindowButtonMotionFcn',[])
            set(src,'WindowButtonUpFcn',[])
            uiresume(fh);
        end
        function zoom(~,event)
            % HMTC is How Much To Change
            HMTCleft  = winSizeStep*((xinit-pos(1))/(pos(3)-pos(1)));
            HMTCright = winSizeStep*((pos(3)-xinit)/(pos(3)-pos(1)));
            HMTCdown  = winSizeStep*((yinit-pos(2))/(pos(4)-pos(2)));
            HMTCup    = winSizeStep*((pos(4)-yinit)/(pos(4)-pos(2)));
            if event.VerticalScrollCount < 0 %up
                log(end+1,:)=[toc,3,xinit,yinit,winSize(1),winSize(2)];
                if winSize(1)<maxWin
                    pos=[pos(1)-HMTCleft pos(2)-HMTCdown pos(3)+HMTCright pos(4)+HMTCup];
%                     ratio=winSizeStep/winSize(1);
%                     winSize(1)=winSize(1)+winSizeStep;
%                     winSize(2)=winSize(2)+winSize(2)*ratio;
%                     log(end,5:6)=[winSize(1) winSize(2)];
                end
            elseif event.VerticalScrollCount > 0 %down
                log(end+1,:)=[toc,4,xinit,yinit,winSize(1),winSize(2)];
                if winSize(1)>minWin
                    ratio=winSizeStep/winSize(1);
                    winSize(1)=winSize(1)-winSizeStep;
                    winSize(2)=winSize(2)-winSize(2)*ratio;
                    log(end,5:6)=[winSize(1) winSize(2)];
                end
            end
            pos
            %         x0temp=x0-(winSize(2)-size(img_temp,2)*imgSize)/2;
            %         y0temp=y0-(winSize(1)-size(img_temp,1)*imgSize)/2;
            %         x1temp=x0temp+winSize(2);
            %         y1temp=y0temp+winSize(1);
            plotSquare(xinit,yinit,pix,pos,src)
        end
    end
%% functions
    function plotSquare(xinit,yinit,pix,pos,~)
        if xinit-pix<1
            xinit=pix+1;
        end
        if yinit-pix<1
            yinit=pix+1;
        end
        if xinit+pix>size(img,2)
            xinit=size(img,2)-pix;
        end
        if yinit+pix>size(img,1)
            yinit=size(img,1)-pix;
        end
        img_temp(yinit-pix:yinit+pix,xinit-pix:xinit+pix,1:3)=img(yinit-pix:yinit+pix,xinit-pix:xinit+pix,1:3);
        %imagesc(img_temp,[minColor maxColor])
        image(img_temp)
        % axis off
%         x0temp=x0-(winSize(2)-size(img_temp,2)*imgSize)/2;
%         y0temp=y0-(winSize(1)-size(img_temp,1)*imgSize)/2;
%         x1temp=x0temp+winSize(2);
%         y1temp=y0temp+winSize(1);
        set(fh,'position',pos)
        set(gca,'xtick',[],'ytick',[])
        %set(gca,'ytick',[])
        %colormap('gray');
        img_temp=background;%uint8(zeros(size(img)));
    end
end