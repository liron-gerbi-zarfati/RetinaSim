% run step by step or else!!!
% CPD   0.625 1.25 2.5
% bulge 1 4
%%
CPD=0.625;
bulge_deg=1;
experiment4(CPD,bulge_deg);

thr1=plotOP;
movefile('output.mat','output1.mat')

bulge_deg=4;
experiment4(CPD,bulge_deg);

thr2=plotOP;
movefile('output.mat','output2.mat')

CPD=1.25;
bulge_deg=1;
experiment4(CPD,bulge_deg);

thr3=plotOP;
movefile('output.mat','output3.mat')

bulge_deg=4;
experiment4(CPD,bulge_deg);

thr4=plotOP;
movefile('output.mat','output4.mat')

CPD=2.5;
bulge_deg=1;
experiment4(CPD,bulge_deg);

thr5=plotOP;
movefile('output.mat','output5.mat')

bulge_deg=4;
experiment4(CPD,bulge_deg);

thr6=plotOP;
movefile('output.mat','output6.mat')

thr=[thr1,thr2;thr3,thr4;thr5,thr6];
figure;
axes1 = axes('XTick',[0.625 1.25 2.5]);
hold on
plot([0.625,1.25,2.5],thr);
legend('bulge = 1deg','bulge = 4deg')
title('Threshold by CPD and bulge size')
xlabel('CPD')
ylabel('Threshold (Webber contrast)')
grid on
