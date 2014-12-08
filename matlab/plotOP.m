function thr=plotOP
output=load('output.mat');
output=output.output;


err=find(output(:,2)~=output(:,3)); %errections
err=err(2:end);
err=err([1;1+find(diff(err)>3)]);
for erri=1:length(err)
    Err(erri,1)=err(erri);
    count=0;
    goodi=err(erri);
    while count<2
        goodi=goodi-1;
        if output(goodi,4)==output(goodi-1,4)
            count=count+1;
        else
            count=0;
        end
    end
    Err(erri,2)=goodi;
    Err(erri,3)=output(goodi,4);
end


figure;

hold on
plot(1:size(output,1),output(:,4)./0.5,'g.')
errors=find(output(:,3)~=output(:,2));
plot(errors,output(errors,4)./0.5,'r.')
xlabel('trials')
ylabel('Webber contrast')
thr=mean(Err(:,3))/0.5;
thrLine=repmat(thr,1,size(output,1));
plot(Err(:,2),Err(:,3)/0.5,'ok')
plot(thrLine,'r--')
legend('correct','error','threshold raw','threshold mean')
plot(1:size(output,1),output(:,4)./0.5)