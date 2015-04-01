function [Sampled_Mat]= Phosphane_the_image(Im,Phos_pix,Orig)

[BLOCKS,Coor]=Block_the_Img(Im,Phos_pix,Phos_pix);
Center_of_Block=floor(Phos_pix/2)+1; %find center location relative to each block;
Sampled_Mat=nan(size(Im));
L=length(Coor{1});
for i=1:length(BLOCKS)
    Conv_Intensity=double(BLOCKS{i}(Center_of_Block,Center_of_Block))/255;
    OrigBlock = imadjust(Orig,[0;1],[0; Conv_Intensity]); 
    Sampled_Mat(Coor{i}(1,1):Coor{i}(1,L),Coor{i}(2,1):Coor{i}(2,L))=OrigBlock;
end

end