function  startdraw
pix=30;
img=rgb2gray(imread('peppers.png'));
img_temp=zeros(size(img));
fh= figure('units','normalized','outerposition',[0 0 1 1],'toolbar','none','MenuBar','none');
ha = axes('Xlim', [1 size(img,2)],'Ylim',[1 size(img,2)],'XTick',[],'YTick',[]);
set(gca,'color','k')
set(gcf,'color',[0.1 0.1 0.1])
set(fh,'WindowButtonDownFcn',@Mouse_Press);
uiwait(fh);
    function Mouse_Press(src,~)
        %set(src,'pointer','crosshair')
        cp = get(ha,'CurrentPoint');
        xinit = round(cp(1,1));
        yinit = round(cp(1,2));
        %       hl = line('XData',xinit,'YData',yinit,...
        %              'color','k','linewidth',2);
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
        img_temp(yinit-pix:yinit+pix,xinit-pix:xinit+pix)=img(yinit-pix:yinit+pix,xinit-pix:xinit+pix);
        imagesc(img_temp);
        % axis off
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        colormap('gray');
        img_temp=zeros(size(img));
        
        set(src,'WindowButtonMotionFcn',@movedraw)
        set(src,'WindowButtonUpFcn',@enddraw)
        set(src,'WindowScrollWheelFcn',@mytest)
        function movedraw(~,~)
            
            cp = get(ha,'CurrentPoint');
            xinit = round(cp(1,1)); yinit = round(cp(1,2));
            
            %               xdat = [get(hl,'XData'),cp(1,1)];
            %               ydat = [get(hl,'YData'),cp(1,2)];
            %               set(hl,'XData',xdat,'YData',ydat);
            %               if xinit-10<0 &yinit-10<0
            %               xinit=11;
            %               yinit=11;
            %               end
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
            try
                img_temp(yinit-pix:yinit+pix,xinit-pix:xinit+pix)=img(yinit-pix:yinit+pix,xinit-pix:xinit+pix);
            catch
                disp(num2str([yinit-pix yinit+pix xinit-pix xinit+pix]))
            end
            imagesc(img_temp)
            %axis off
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            colormap('gray');
            img_temp=zeros(size(img));
            %               drawnow
        end
        function enddraw(src,~)
            set(src,'Pointer','arrow')
            set(src,'WindowButtonMotionFcn',[])
            set(src,'WindowButtonUpFcn',[])
            uiresume(fh);
        end
        function mytest(~,~)
            %               figure;
            %               bla lna nksanfjkhg;kf
        end
    end
end