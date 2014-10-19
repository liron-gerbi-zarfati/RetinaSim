function mini_gui 

img=rgb2gray(imread('peppers.png'));
img2=rgb2gray(imread('vegetables1.jpg'));
img3=rgb2gray(imread('vegetables2.jpg'));
img4=rgb2gray(imread('vegetables3.jpg'));
img5=rgb2gray(imread('vegetables4.jpg'));

log=[];
actions={'up';'down';'left';'right';'quit'};
imagesc(img);
colormap('gray');
fh= figure('outerposition',[200 100 size(img,2) size(img,1)],'toolbar','none','MenuBar','none');
set(fh,'WindowKeyPressFcn',@Key_Press);
i=1;
    function Key_Press(~,keyData)
        switch keyData.Key 
            case 'uparrow'   
                log(end+1,:)=[toc,1];
                i=i+1;
                imagesc(eval(['img' num2str(i)]));
                colormap('gray');
            case 'downarrow'
                log(end+1,:)=[toc,2];
                i=i+1;
                imagesc(eval(['img' num2str(i)]));
                colormap('gray');
            case 'leftarrow'                   
                log(end+1,:)=[toc,3];
                i=i+1;
                imagesc(eval(['img' num2str(i)]));
                colormap('gray');
            case 'rightarrow'
                log(end+1,:)=[toc,4];
                i=i+1;
                imagesc(eval(['img' num2str(i)]));
                colormap('gray');
            case 'q'
                log(end+1,:)=[toc,5];
                close
        end
        save (['log'],'log','actions')
    end
 
end