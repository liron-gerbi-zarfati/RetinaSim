cd ~/Desktop
!rm output.mat
tic
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
toc
