function  startdraw
img=rgb2gray(imread('peppers.png'));
img_temp=zeros(size(img));
fh= figure;
ha = axes('Xlim', [1 size(img,2)],'Ylim',[1 size(img,2)],'XTick',[],'YTick',[]);
set(fh,'WindowButtonDownFcn',@Mouse_Press)
uiwait(fh)
    function Mouse_Press(src,~)
        set(src,'pointer','crosshair')
        cp = get(ha,'CurrentPoint');
        xinit = round(cp(1,1)); yinit = round(cp(1,2));
%       hl = line('XData',xinit,'YData',yinit,...
%              'color','k','linewidth',2);
%       if xinit-10<0 &yinit-10<0
%           xinit=11;
%           yinit=11;
%       end
            
        img_temp((yinit )-10:yinit +10,xinit-10:xinit+10)=img(yinit -10:yinit +10,xinit-10:xinit+10);
        imagesc(img_temp);
        axis off
        colormap('gray');
        img_temp=zeros(size(img));

        set(src,'WindowButtonMotionFcn',@movedraw)
        set(src,'WindowButtonUpFcn',@enddraw)
        set(src,'WindowScrollWheelFcn',@mytest) 
            function movedraw(~,~)
                cp = get(ha,'CurrentPoint');
                xinit = cp(1,1); yinit = cp(1,2);
                 
%               xdat = [get(hl,'XData'),cp(1,1)];
%               ydat = [get(hl,'YData'),cp(1,2)];
%               set(hl,'XData',xdat,'YData',ydat);
%               if xinit-10<0 &yinit-10<0
%               xinit=11;
%               yinit=11;
%               end
                img_temp((yinit )-10:yinit +10,xinit-10:xinit+10)=img(yinit -10:yinit +10,xinit-10:xinit+10);
                imagesc(img_temp)
                axis off
                colormap('gray');
                img_temp=zeros(size(img));
%               drawnow
            end
            function enddraw(src,~)
                set(src,'Pointer','arrow')
                set(src,'WindowButtonMotionFcn',[])
                set(src,'WindowButtonUpFcn',[])
                uiresume(fh)
            end
            function mytest(~,~)
%               figure;
%               bla lna nksanfjkhg;kf
            end
    end
end