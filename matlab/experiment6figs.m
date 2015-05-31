function experiment6(CPD,bulge_deg)
cd ~/Desktop
if ~exist('CPD','var')
    CPD=[];
end
if isempty(CPD)
    CPD=2.14;
end
if ~exist('bulge_deg','var')
    bulge_deg=[];
end
if isempty(bulge_deg)
    bulge_deg=0.5;
end
trialLim=5; % max trial length (seconds)
rim_col= 1/1.5; % 0.6667 background is 50% Webber contrast for 1 figure

step1=0.25;% in dB
step2=0.1;
step=1/10.^(step1/10); % dB to ratio

detections=1;

square_col= 1;
msg= true;
jitter=[600 800];


%% make phosphene matrix
maxTrials=3000;
% screen size and angles
% get screen size
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



%figure('Units','pixels','Position',[100 100 n m])
% set(gca,'Position',[0 0 1 1])
%% Image's parameters (phosphene area)


%height=900;
%widthPix=heightPix;
square_size_deg=5;                     %internal square size in degrees
square_size=round(square_size_deg/heightDeg*heightPix); %intenal square size in pixels

%% Bulge's parameters
%bulge sizes in degrees
bulge_pix=round((bulge_deg./FOV)*heightPix);      %bulge sizes in pixels

%% Resolutions parameters
res=CPD;                                        %Desired resolutions in CPD (2.14 CPD is 42.88*42.88 phosphenes. we want CPD 1.25, 2.5 10)
num_phos_res=round(res.*2*heightDeg);                %number of phosphenes in the whole image per resolution
pix_res=round(heightPix./num_phos_res);           % width of a phosphene in pixels
sigma = pix_res^0.5;
h = fspecial('gaussian', pix_res, sigma);
h=h-min(min(h));
h=h./max(max(h));
Phosphene_Matrix=repmat(h,num_phos_res,num_phos_res);
%figure;
pixStartX=round(Pix_SS(3)/2-length(Phosphene_Matrix)/2);
pixStartY=round(Pix_SS(4)/2-length(Phosphene_Matrix)/2);


%% make shape
squareSizePhos=round(square_size/pix_res);
squareInd=false(num_phos_res);
phosStart=floor((num_phos_res-squareSizePhos+1)/2)+1;
phosEnd=phosStart+squareSizePhos-1;
squareInd(phosStart:phosEnd,phosStart:phosEnd)=true;
bulgePhos=ceil(bulge_pix/pix_res); % 2 phosphenes if at optimal position the bulge covers 2 phosphene centers
bulgeInd=false(num_phos_res);
bulgeStartY=floor(num_phos_res/2+0.5)-floor(bulgePhos/2)+1;
bulgeEndY=bulgeStartY+bulgePhos-1;
bulgeInd(phosEnd+1:phosEnd+bulgePhos,bulgeStartY:bulgeEndY)=true;

%imagesc(weights);

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

%% make cross
crossSize=10;
cross=zeros(size(Phosphene_Matrix));
cross(floor(length(Phosphene_Matrix)/2)-crossSize:ceil(length(Phosphene_Matrix)/2)+crossSize,round(length(Phosphene_Matrix)/2))=1;
cross(round(length(Phosphene_Matrix)/2),floor(length(Phosphene_Matrix)/2)-crossSize:ceil(length(Phosphene_Matrix)/2)+crossSize)=1;



%% display desired distance and run experiment
cfg=[];
cfg.jitter=jitter;
cfg.pos=[pixStartX pixStartY length(Phosphene_Matrix) length(Phosphene_Matrix)];
cfg.weights=squareInd+bulgeInd;
cfg.Phosphene_Matrix=Phosphene_Matrix;
cfg.phosInd=phosInd;
cfg.cross=cross;
cfg.step=step;
if msg
    uiwait(msgbox(['Please sit ',num2str(round(distanceFromScreen)),'cm From screen']));
end

fh=figure('Units','pixels','Position',Pix_SS,'toolbar','none','MenuBar','none');
%fh=figure; % debug mode...
colormap gray
imagesc(cfg.cross,[0 1]);
set(gca,'Units','pixels','Position',cfg.pos)
set(gcf,'Color',[0 0 0]);
set(0,'PointerLocation',[-1 -1])
drawnow
pause
set(fh,'WindowKeyPressFcn',@Key_Press);

trialBeg=0;
trialTime=0;
stop=false;
triali=1;
direction=randi([1 4],1);
output=[];
%errors=0;
detect=0;
prev=0; % checks if last trial was correct to detect 3 changes from error to detection
Prev=0; % checks sequences of three good trials to make harder level
%threshold=1;
%time0=0;
%time1=0;
trial(cfg);%    jitter,cross,img,
%    Log(triali)=output;
%     triali=triali+1;
%     rim_col=rim_col-0.1;
% Log=output;
% %close
% save Log Log
% disp('end')


%% functions
    function Key_Press(~,keyData)
        %log(end+1,1:2)=[toc,list(i)];
        %output(
        %time1=toc;
        output(triali,1:4)=[toc 0 direction square_col-rim_col];
        switch keyData.Key
            case 'uparrow'
                output(triali,2)=1;
            case 'downarrow'
                output(triali,2)=3;
            case 'leftarrow'
                output(triali,2)=2;
            case 'rightarrow'
                output(triali,2)=4;
            case 'q'
                output(triali,2)=5;
                stop=true;
                close all
                save output output
                return
                %i=length(list);
            case 'space'
                output(triali,2)=6;
        end
        %output
        save output output
        if output(triali,2)==direction && prev==0
            detect=detect+1;
            if detect==detections+1
                if detections==1 % first error
                    detections=3;
                    prev=2; % needs only one good trial next time (1 up 1 down only this time)
                    Prev=0; 
                    detect=1; % start counting 3 errors from now
                    step=1/10.^(step2/10);
                else
                    %threshold=square_col-rim_col;
                    close all
                    save output output
                    stop=true;
                    return
                end
            end
            
        end
        
        if triali<maxTrials
            if output(triali,2)==direction
                prev=1;
                Prev=Prev+1; % counts three for '3 up 1 down' staircase
                if Prev==3
                    rim_col=rim_col/step;
                    Prev=0;
                end
            else
                rim_col=rim_col*step;
                prev=0;
                Prev=0;
            end
            if rim_col>square_col
                rim_col=square_col;
            elseif rim_col<0
                rim_col=0;
            end
            direction=randi([1 4],1);
            
            triali=triali+1;
            %timeOK=true; % to allow while loop to check trial time
            trial(cfg);
        else
            disp('end')
            stop=true;
            close all
            return
        end
    end
%         close
%         log(end,4)=stimType(list(i),4);
%         log(end,5)=stimType(list(i),3);
%         save ('log','log','actions','stimType')
%         i=i+1;
%         if i<(length(list)+1)
%             imagesc(cross);
%             pause(dur(i));
%             imagesc(imgs(:,:,list(i)));
%             colormap('gray');
%             tic
%         else
%             close
%         end


    function trial(cfg)
        
        %output(triali,1:3)=[0 0 direction];
        dur=randi(cfg.jitter,1)./1000;
        %disp(num2str(dur))
        imagesc(cfg.cross,[0 1]);
        drawnow
        ticCross1=tic;
        crossEnd=0;
        while crossEnd<dur;
            ticCross2=tic;
            crossEnd=double((ticCross2-ticCross1))/1000000;
        end   
        
        
        %         tic;
        %         while toc<dur
        %         end
        %pause(dur)
        %close;
        % make phosphenized img
        weights=cfg.weights;
        weights(weights>0)=square_col;
        weights(weights==0)=rim_col;
        img=zeros(size(cfg.Phosphene_Matrix));
        img(:)=weights(cfg.phosInd(:));
        img=img.*cfg.Phosphene_Matrix;
        % img faces right
        
%         img(:,:,2)=flipud(img); % flip LR at random to counterbalance asymmetric imgs
%         img=img(:,:,round(rand(1)+1));
%         img=imrotate(img,90*direction);
        imagesc(img,[0 1]);
        drawnow
        pause(1)
        save([num2str(CPD),'_',num2str(bulge_deg),'.mat'],'img')
        close all
        return
        tic;
        trialBeg=tic;
        trialTime=0;
        pause(trialLim)
%         
%         while timeOK; %trialTime<trialLim
            ticTemp=tic;
            trialTime=double((ticTemp-trialBeg))/1000000;
%             if trialTime>=trialLim
%                 timeOK=false;
%             end
%         end
%         disp('ok')
%         close
%         return
        if trialTime>=trialLim && stop==false
            output(triali,1:4)=[trialLim 0 direction square_col-rim_col];
            save output output
            rim_col=rim_col*step;
            prev=0;
            Prev=0;
            if rim_col>square_col
                rim_col=square_col;
            elseif rim_col<0
                rim_col=0;
            end
            direction=randi([1 4],1);
            
            triali=triali+1;
            trial(cfg);
        end
        %pause
    end
end
