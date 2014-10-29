load log
RT=log(:,1);
catchTrials=stimType(:,2)==0;
realTrials=stimType(:,2)>0;
largeRim=stimType(:,1)==40;
largeRim=find(largeRim.*realTrials);
largeRimLog=find(ismember(log(:,2),largeRim));
noRim=stimType(:,1)==0;
noRim=find(noRim.*realTrials);
noRimLog=find(ismember(log(:,2),noRim));

noRimErr=find(log(noRimLog,3)-log(noRimLog,4));
largeRimErr=find(log(largeRimLog,3)-log(largeRimLog,4));


