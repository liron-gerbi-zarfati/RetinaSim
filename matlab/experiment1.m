function experiment1(imgs,stimType)
% loaded=load('imgs.mat')
% imgs=loaded.imgs;
% stimType=loaded.stimType;
% clear loaded
angleFig=30; % degrees
distanceFromScreen=45; % cm
reps=10; % how many repetitions per item
numTrials=300;


crossSize=10; % size of cross
jitter=[600 800]; % min max time to show cross


% set figure size and position
angleFig=degtorad(angleFig);
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','centimeters')
CM_SS = get(0,'screensize');
widthFig=atan(angleFig)*distanceFromScreen;  %cm
widthFig=round(widthFig/CM_SS(3)*Pix_SS(3)); %pix
%position=[round(Pix_SS(3)/2-widthFig/2),round(Pix_SS(4)/2-widthFig/2),round(Pix_SS(3)/2-widthFig/2)+widthFig-1,round(Pix_SS(4)/2-widthFig/2)+widthFig-1];
position=[round(Pix_SS(3)/2-widthFig/2),round(Pix_SS(4)/2-widthFig/2),widthFig,widthFig];
%%
cross=zeros(size(imgs,1),size(imgs,2));
cross(floor(size(imgs,1)/2)-crossSize:ceil(size(imgs,1)/2)+crossSize,round(size(imgs,2)/2))=1;
cross(round(size(imgs,1)/2),floor(size(imgs,2)/2)-crossSize:ceil(size(imgs,2)/2)+crossSize)=1;

numStim=size(imgs,3);
list=repmat(1:numStim,1,reps);
[~,order]=sort(rand(size(list)));
list=list(order);
if length(list)>numTrials
    list=list(1:numTrials);
end
dur=randi(jitter,1,reps*size(imgs,3))./1000;% how much time between trials, showing cross
log=[];
actions={'up';'left';'down';'right';'quit'};

fh= figure('outerposition',position,'toolbar','none','MenuBar','none');
%movegui(fh,'center');
i=1;
imagesc(cross);
colormap('gray');
set(gca,'position',[0 0 1 1],'units','normalized')
pause(dur(i)+1);
imagesc(imgs(:,:,list(i)));
%colormap('gray');
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
            case 'space'
                log(end,3)=6;
        end
        log(end,4)=stimType(list(i),4);
        log(end,5)=stimType(list(i),3);
        save ('log','log','actions','stimType')
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