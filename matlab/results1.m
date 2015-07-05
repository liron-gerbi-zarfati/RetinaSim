cd ~/Desktop/results
DIR=dir;
count=0;
shapes={'^','o','s','d','*','>','.'};
figure;
hold on
for diri=1:length(DIR)
    try
        load([DIR(diri).name,'/thr.mat'])
        count=count+1;
        Thr(count,1:3,1:3)=thr;
        Thr=thr./(1-thr);
        semilogx([0.6,1,5/3],Thr,shapes{count},'linewidth',5)
        semilogx([0.6,1,5/3],Thr,'linewidth',2)
    end
end
set(gca,'Xtick',[0.6 1 5/3])   
% semilogx([0.6,1,5/3],thr,'^','linewidth',5)
% hold on
% semilogx([0.6,1,5/3],thr,'linewidth',2)
xlim([0.5 2])
legend('small','medium','large')
set(gca,'Xtick',[0.6 1 5/3])
ylim([0 0.7])
ylim([0 0.6])
xlabel('CPD')
ylabel('Webber contrast (I-Ib)/Ib')