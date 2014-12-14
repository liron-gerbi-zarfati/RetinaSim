function thr=plotOP(outputNum)
if ~exist('outputNum','var')
    outputNum='';
else
    outputNum=num2str(outputNum);
end
output=load(['output',outputNum,'.mat']);
output=output.output;


Err=find(output(:,2)~=output(:,3));
Err=Err(2:end);
Err=Err([1;1+find(diff(Err)>3)]);
for erri=2:length(Err)
    [~,goodi]=max(output(Err(erri-1):Err(erri),4));
    goodi=goodi-1+Err(erri-1);
    Good(erri-1,1)=goodi;
end
thrRaw=output([Err;Good],4)/(1/1.5);
thr=mean(thrRaw);
thrLine=repmat(thr,1,size(output,1));
errors=find(output(:,3)~=output(:,2));
correct=find(output(:,3)==output(:,2));
figure;
hold on
plot(correct,output(correct,4)./(1/1.5),'g.')
plot(errors,output(errors,4)./(1/1.5),'rx')
plot([Err;Good],thrRaw,'ok')
plot(thrLine,'r--')
legend('correct','error','threshold raw','threshold mean')
xlabel('trials')
ylabel('Webber contrast')
plot(1:size(output,1),output(:,4)./(1/1.5))