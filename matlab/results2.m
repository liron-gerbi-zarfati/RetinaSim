cd ~/Desktop/results
DIR=dir;
count=0;
%shapes={'^','o','s','d','*','>','.'};

for diri=1:length(DIR)
    try
        load([DIR(diri).name,'/thr.mat'])
        count=count+1;
        Thr(count,1:3,1:3)=thr;
        
    end
end



Thr=Thr./(1-Thr);
thr=squeeze(mean(Thr,1));
figure;
semilogx([0.6,1,5/3],thr(:,1),'linewidth',2,'color','b')
hold on
semilogx([0.6,1,5/3],thr(:,2),'linewidth',2,'color','r')
semilogx([0.6,1,5/3],thr(:,3),'linewidth',2,'color','g')
set(gca,'Xtick',[0.6 1 5/3])   
xlim([0.5 2])
legend('small','medium','large')
title('Threshold by CPD and Bulge Size, N = 8')
ylim([0 0.5])
xlabel('CPD')
ylabel('Webber contrast (I-Ib)/Ib')

dataA=mean(Thr(:,:,1),2);
dataB=mean(Thr(:,:,2),2);
dataC=mean(Thr(:,:,3),2);
[~,p1]=ttest(dataA,dataB,[],'right')
[~,p2]=ttest(dataB,dataC,[],'right')
bars=[mean(dataA),mean(dataB),mean(dataC)];
err=[std(dataA)/sqrt(8),std(dataB)/sqrt(8),std(dataC)/sqrt(8)];
p1=round(p1*10000)/10000;
p2=round(p2*10000)/10000;
figure1=figure;
errorbar([1 2 3],bars,err,'k')
hold on
set(gca,'Xtick',[1 2 3],'Xticklabel',{'small','medium','large'})   
xlim([0.5 3.5])
title('Threshold by Bulge Size , N = 8')
ylim([0 0.5])
xlabel('Bulge Width')
ylabel('Webber contrast (I-Ib)/Ib')
annotation(figure1,'textbox',...
    [0.348214285714285 0.739476190476191 0.139285714285714 0.0714285714285714],...
    'String',{['* p=',num2str(p1)]});
% Create textbox
annotation(figure1,'textbox',...
    [0.561071428571427 0.736142857142858 0.139285714285714 0.0714285714285714],...
    'String',{['* p=',num2str(p2)]});
plot(1,bars(1),'^b')
plot(2,bars(2),'^r')
plot(3,bars(3),'^g')


dataA=mean(Thr(:,1,:),3);
dataB=mean(Thr(:,2,:),3);
dataC=mean(Thr(:,3,:),3);
[~,p1]=ttest(dataA,dataB,[],'right')
[~,p2]=ttest(dataB,dataC,[],'right')
bars=[mean(dataA),mean(dataB),mean(dataC)];
err=[std(dataA)/sqrt(8),std(dataB)/sqrt(8),std(dataC)/sqrt(8)];
p1=round(p1*10000)/10000;
p2=round(p2*10000)/10000;

figure2=figure;
errorbar([1 2 3],bars,err,'k')
hold on

set(gca,'Xtick',[1 2 3],'Xticklabel',[0.6 1 5/3])   
xlim([0.5 3.5])
title('Threshold by CPD , N = 8')
ylim([0 0.5])
xlabel('CPD')
ylabel('Webber contrast (I-Ib)/Ib')
annotation(figure2,'textbox',...
    [0.348214285714285 0.739476190476191 0.139285714285714 0.0714285714285714],...
    'String',{['* p=',num2str(p1)]});
% Create textbox
annotation(figure2,'textbox',...
    [0.561071428571427 0.736142857142858 0.139285714285714 0.0714285714285714],...
    'String',{['* p=0.000']});