function experiment(imgs)
reps=3; % how many repetitions per item
crossSize=10; % size of cross
jitter=[600 800]; % min max time to show cross
%%
cross=zeros(size(imgs,1),size(imgs,2));
cross(floor(size(imgs,1)/2)-crossSize:ceil(size(imgs,1)/2)+crossSize,round(size(imgs,2)/2))=1;
cross(round(size(imgs,1)/2),floor(size(imgs,2)/2)-crossSize:ceil(size(imgs,2)/2)+crossSize)=1;

numStim=size(imgs,3);
list=repmat([1:numStim],1,reps);
[~,order]=sort(rand(size(list)));
list=list(order);
dur=randi(jitter,1,12)./1000;% how much time between trials, showing cross
log=[];
actions={'up';'left';'down';'right';'quit'};

fh= figure('outerposition',[200 100 size(imgs,2) size(imgs,1)],'toolbar','none','MenuBar','none');
movegui(fh,'center');
i=1;
imagesc(cross);
colormap('gray');
pause(dur(i)+1);
imagesc(imgs(:,:,list(i)));
colormap('gray');
tic


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
                log(end,3)=5;
                close
                i=length(list);
        end
        save ('log','log','actions')
        i=i+1;
        if i<(length(list)+1)
            imagesc(cross);
            pause(dur(i));
            imagesc(imgs(:,:,list(i)));
            colormap('gray');
            tic
        else
            close
        end
        
    end
end