function plotOP
output=load('output.mat');
output=output.output;
figure;
plot(1:size(output,1),output(:,4))
hold on
plot(1:size(output,1),output(:,4),'g.')
errors=find(output(:,3)~=output(:,2));
plot(errors,output(errors,4),'r.')
