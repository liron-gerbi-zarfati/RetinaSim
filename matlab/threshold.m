function plotOP
output=load('output.mat');
output=output.output;
figure;
plot(1:size(output,1),output(:,4)./0.5)
hold on
plot(1:size(output,1),output(:,4)./0.5,'g.')
errors=find(output(:,3)~=output(:,2));
plot(errors,output(errors,4)./0.5,'r.')
xlabel('trials')
ylabel('Webber contrast')
