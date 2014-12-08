This script failed
CPD=2.14;
bulge_deg=0.5;
step=0.5;%dB
detections=1; % after how many reversals to stop
rim_col=0.5;
experiment3(CPD,bulge_deg,step,detections,rim_col);
pause(1)
movefile('output.mat','output1.mat')
load output1
rim_col=0.5+output(end,4);
step=0.25;
detections=3;
experiment3(CPD,bulge_deg,step,detections,rim_col,false);

