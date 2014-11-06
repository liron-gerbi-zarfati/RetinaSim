load log
%stimType(:,6)=2.5*stimType(:,1)+stimType(:,2);
catchRimi=find(ismember(log(:,2),find(stimType(:,1)==0)));
%catchRimi=find(ismember(log(:,2),find(stimType(:,6)==100)));
resp=log(catchRimi,3);
rt=log(catchRimi,1);
correct=resp==6;
rtM=mean(rt(correct));
rtSD=std(rt(correct));
err=1-sum(resp==6)/length(resp);
resCatchRim=[err,rtM,rtSD];

% catchNoRimi=find(ismember(log(:,2),find(stimType(:,6)==0)));
% resp=log(catchNoRimi,3);
% err=1-sum(resp==6)/length(resp);
% rt=log(catchNoRimi,1);
% correct=resp==6;
% rtM=mean(rt(correct));
% rtSD=std(rt(correct));
% resCatchNoRim=[err,rtM,rtSD];


condCount=1;
resTable=[];
c={'r','b','k','c'};
ci=0;
for sizei=8:4:20
    ci=ci+1;
    %for typei=[10,20,30,110,120,130]
        triali=find(ismember(log(:,2),find(stimType(:,1)==sizei)));
        plot(log(triali,5),log(triali,1),['.',c{ci}]);
        hold on
%         resp=log(triali,3);
%         corrResp=log(triali,4);
%         correct=resp==corrResp;
%         err=1-sum(correct)/length(resp);
%         rt=log(triali,1);
%         rtM=mean(rt(correct));
%         rtSD=std(rt(correct));
%         resTable(condCount,1:3)=[err,rtM,rtSD];
%         condCount=condCount+1;
    %end
end


% table=[resCatchRim;resTable(1:3,:)];
% table=[table;resCatchNoRim;resTable(4:6,:)];
% 
% 
% condCount=1;
% resTable=[];
% for typei=[10,20,30,110,120,130]
%     triali=find(ismember(log(:,2),find(stimType(:,6)==typei)));
%     resp=log(triali,3);
%     corrResp=log(triali,4);
%     correct=resp==corrResp;
%     err=1-sum(correct)/length(resp);
%     rt=log(triali,1);
%     rtM=mean(rt(correct));
%     rtSD=std(rt(correct));
%     resTable(condCount,1:3)=[err,rtM,rtSD];
%     condCount=condCount+1;
% end
% table=[resCatchRim;resTable(1:3,:)];
% table=[table;resCatchNoRim;resTable(4:6,:)];
% 
% 
% % plot with error bars
% x = 1:4;
% y = table(1:4,2);
% lower = y - table(1:4,3);
% upper = y + table(1:4,3);
% L = y - lower;
% U = upper - y;
% figure;
% hold('on');
% plot( x, y, 'bo' );
% errorbar( x, y, L, U, 'b', 'Marker', 'none', 'LineStyle', 'none' );
% x = 1.15:1:4.15;
% y = table(5:8,2);
% lower = y - table(5:8,3);
% upper = y + table(5:8,3);
% L = y - lower;
% U = upper - y;
% plot( x, y, 'ro' );
% errorbar( x, y, L, U, 'r', 'Marker', 'none', 'LineStyle', 'none' );
% 
% title('catch                 small                  medium                  big')
% ylabel('RT (s)')
% legend('no Rim','','Rim')
% 
% 


% RT=log(:,1);
% catchTrials=stimType(:,2)==0;
% realTrials=stimType(:,2)>0;
% largeRim=stimType(:,1)==40;
% largeRim=find(largeRim.*realTrials);
% largeRimLog=find(ismember(log(:,2),largeRim));
% noRim=stimType(:,1)==0;
% noRim=find(noRim.*realTrials);
% noRimLog=find(ismember(log(:,2),noRim));
% 
% noRimErr=find(log(noRimLog,3)-log(noRimLog,4));
% largeRimErr=find(log(largeRimLog,3)-log(largeRimLog,4));
% noRimErrRate=length(noRimErr)./length(noRimLog);
% largeRimErrRate=length(largeRimErr)./length(largeRimLog);






