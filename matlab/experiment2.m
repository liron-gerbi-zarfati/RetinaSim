function experiment2(bulge_deg)
CPD=2.14;
if ~exist('bulge_deg','var')
    bulge_deg=0.5;
end
rim_col= 0.5;
square_col= 0.6;
jitter=[600 800];
step=0.01;
detections=3; % how many detections to declare threshold
%% make phosphene matrix
maxTrials=300;
% screen size and angles
% get screen size
set(0,'units','pixels')
Pix_SS = get(0,'screensize');
set(0,'units','centimeters')
CM_SS = get(0,'screensize');
pixelSize=CM_SS(3)/Pix_SS(3);

%widthFig=atan(angleFig)*distanceFromScreen;  %cm
%widthFig=round(widthFig/CM_SS(3)*Pix_SS(3)); %pix


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
phosStart=floor((num_phos_res-squareSizePhos)/2)+1;
phosEnd=phosStart+squareSizePhos-1;
squareInd(phosStart:phosEnd,phosStart:phosEnd)=true;
bulgePhos=ceil(bulge_pix/pix_res); % 2 phosphenes if at optimal position the bulge covers 2 phosphene centers
bulgeInd=false(num_phos_res);
bulgeStartY=floor(num_phos_res/2+0.5)-floor(bulgePhos/2);
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
uiwait(msgbox(['Please sit ',num2str(round(distanceFromScreen)),'cm From screen']));

fh=figure('Units','pixels','Position',Pix_SS,'toolbar','none','MenuBar','none');
%fh=figure;
colormap gray
imagesc(cfg.cross,[0 1]);
set(gca,'Units','pixels','Position',cfg.pos)
set(gcf,'Color',[0 0 0]);
set(0,'PointerLocation',[-1 -1])
pause
set(fh,'WindowKeyPressFcn',@Key_Press);
triali=1;
direction=randi([1 4],1);
output=[];
%errors=0;
detect=0;
prev=0; % checks if last trial was correct to detect 3 changes from error to detection
Prev=0; % checks sequences of three good trials to make harder level
threshold=1;
%time0=0;
%time1=0;
trial(square_col,rim_col,direction,cfg);%    jitter,cross,img,
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
                close
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
                threshold=square_col-rim_col;
                close
                save output output threshold
                return
            end
            
        end
        
        if triali<maxTrials
            if output(triali,2)==direction
                prev=1;
                Prev=Prev+1; % counts three for '3 up 1 down' staircase
                if Prev==3
                    rim_col=rim_col+step;
                    Prev=0;
                end
            else
                rim_col=rim_col-step;
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
            trial(square_col,rim_col,direction,cfg);
        else
            disp('end')
            close
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
        
 
    function trial(square_col,rim_col,direction,cfg)
        %output(triali,1:3)=[0 0 direction];
        dur=randi(cfg.jitter,1)./1000;
        %disp(num2str(dur))
        imagesc(cfg.cross,[0 1]);
%         tic;
%         while toc<dur
%         end
        pause(dur)
        %close;
        % make phosphenized img
        weights=cfg.weights;
        weights(weights>0)=square_col;
        weights(weights==0)=rim_col;
        img=zeros(size(cfg.Phosphene_Matrix));
        img(:)=weights(cfg.phosInd(:));
        img=img.*cfg.Phosphene_Matrix;
        % img faces right
        img=imrotate(img,90*direction);
        imagesc(img,[0 1]);
        tic;
        %pause
    end
end
