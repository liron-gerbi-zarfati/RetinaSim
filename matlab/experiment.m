function experiment(imgs)
reps=3;
%img=rgb2gray(imread('peppers.png'));
% img2=rgb2gray(imread('vegetables1.jpg'));
% img3=rgb2gray(imread('vegetables2.jpg'));
% img4=rgb2gray(imread('vegetables3.jpg'));
% img5=rgb2gray(imread('vegetables4.jpg'));
numStim=size(imgs,3);
list=repmat([1:numStim],1,reps);
[~,order]=sort(rand(size(list)));
list=list(order);
log=[];
actions={'up';'left';'down';'right';'quit'};

fh= figure('outerposition',[200 100 size(imgs,2) size(imgs,1)],'toolbar','none','MenuBar','none');
i=1;
imagesc(imgs(:,:,list(i)));
tic
colormap('gray');

set(fh,'WindowKeyPressFcn',@Key_Press);

    function Key_Press(~,keyData)
        log(end+1,1:2)=[toc,list(i)];
         switch keyData.Key 
             case 'uparrow'
                log(end,3)=1; 
             case 'downarrow'
                log(end,3)=3;
             case 'leftarrow'                   
                log(end,3)=2;
             case 'rightarrow'
                log(end,3)=4;
                
            case 'q'
                log(end+1,:)=[toc,5];
                close
                i=length(list);
         end
         save (['log'],'log','actions')
         i=i+1;
         if i<(length(list)+1)
             imagesc(imgs(:,:,list(i)));
             colormap('gray');
         else
             close
         end
         
    end
end