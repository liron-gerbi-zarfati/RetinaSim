function [Blocks,Orig_coordinates]=Block_the_Img(Im,window_width,window_height)
%this function ignores the residual pixels left by dividing the n,m: num of
%rows and num of columns of the original image by the n',m': num of rows 
% and columns in each block 

[N,M]=size(Im);
new_N=floor(N/window_height); %number of columns in new matrix
new_M=floor(M/window_width); %numer of rows in new matrix

Blocks=[];
Orig_coordinates=[];
k=1;
for i=1:window_height:new_N*window_height
    for j=1:window_width:new_M*window_width
    Blocks{k}=Im(i:i+window_height-1,j:j+window_width-1);
%     figure;imshow(Blocks{k});
    Orig_coordinates{k}=[i:i+window_height-1;j:j+window_width-1];
    k=k+1;
    end
end

end