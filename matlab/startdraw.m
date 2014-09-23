function  startdraw
img=rgb2gray(imread('peppers.png'));
img(:,:,2)=img;img(:,:,3)=img(:,:,1);
%% set some parameters
pix=30; % half of the square in pixels
% color scale
minColor=0; 
maxColor=255;
% when to ignore wheel (too large or too small pix)
maxPix=56; 
minPix=9;
%% run the experiment
img_temp=uint8(zeros(size(img)));
fh= figure('units','normalized','outerposition',[0 0 1 1],'toolbar','none','MenuBar','none');
ha = axes('Xlim', [1 size(img,2)],'Ylim',[1 size(img,2)],'XTick',[],'YTick',[]);
set(gca,'color','k')
set(gcf,'color',[0.1 0.1 0.1])
set(fh,'WindowButtonDownFcn',@Mouse_Press);
uiwait(fh);
%% callback functions
    function Mouse_Press(src,~)
        %set(src,'pointer','crosshair')
        cp = get(ha,'CurrentPoint');
        xinit = round(cp(1,1));
        yinit = round(cp(1,2));
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
            if event.VerticalScrollCount < 0 && pix<maxPix%up
                pix=pix+5;
            end
            if event.VerticalScrollCount > 0 && pix>minPix%down
                pix=pix-5;
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
        if xinit+pix>size(img,2)
            xinit=size(img,2)-pix;
        end
        if yinit+pix>size(img,1)
            yinit=size(img,1)-pix;
        end
        img_temp(yinit-pix:yinit+pix,xinit-pix:xinit+pix,1:3)=img(yinit-pix:yinit+pix,xinit-pix:xinit+pix,1:3);
        imagesc(img_temp,[minColor maxColor])
        %image(img_temp)
        % axis off
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        colormap('gray');
        img_temp=uint8(zeros(size(img)));
    end
end