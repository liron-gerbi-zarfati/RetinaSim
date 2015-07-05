cd ~/Desktop
!rm output.mat

experiment6(0.6,1,true)
copyfile('output.mat','output1.mat')
thr1=plotOP(1,false);

experiment6(0.6,5)
copyfile('output.mat','output2.mat')
thr2=plotOP(2,false);

experiment6(0.6,10)
copyfile('output.mat','output3.mat')
thr3=plotOP(3,false);

experiment6(1,1)
copyfile('output.mat','output4.mat')
thr4=plotOP(4,false);

experiment6(1,5)
copyfile('output.mat','output5.mat')
thr5=plotOP(5,false);

experiment6(1,10)
copyfile('output.mat','output6.mat')
thr6=plotOP(6,false);

experiment6(5/3,1)
copyfile('output.mat','output7.mat')
thr7=plotOP(7,false);

experiment6(5/3,5)
copyfile('output.mat','output8.mat')
thr8=plotOP(8,false);

experiment6(5/3,10)
copyfile('output.mat','output9.mat')
thr9=plotOP(9,false);

%% YUVAL DOES THIS PART
thr=[thr1,thr2,thr3;thr4,thr5,thr6;thr7,thr8,thr9];
ver='ver1';
save thr thr ver
DIR=input('subject name?','s');
if ~exist(['./results/',DIR],'dir')
    mkdir(['./results/',DIR])
    unix(['mv output*.mat ','./results/',DIR,'/']);
    unix(['mv thr.mat ','./results/',DIR,'/']);
else
    error('folder exists!')
end

% Thr=thr./(1-thr);
% figure;
% semilogx([0.6,1,5/3],Thr,'^','linewidth',5)
% hold on
% semilogx([0.6,1,5/3],Thr,'linewidth',2)
% xlim([0.5 2])
% ylim([0 0.6])
% legend('small','medium','large')
% set(gca,'Xtick',[0.6 1 5/3])
% xlabel('CPD')
% ylabel('Webber contrast (I-Ib)/Ib')


