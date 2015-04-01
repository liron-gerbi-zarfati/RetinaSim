function follow_mouse4(A)
pic=A; %original picture in the size 
h = imshow(zeros(size(A))); %open a new figure;
set (gcf,'WindowButtonMotionFcn', {@mouseMove, pic}); %callback function
end

function mouseMove (object, eventdata, pic)
%read local variables that are required for the processing
Num_pix=14;%evalin('base','Num_pixels_per_phos');
Org=evalin('base','Orig');
% get size of the full image
[N,M]=size(pic);
% Get size of the size of image that should be displayed on screen and
% display a black rectengular in that size
L=20*Num_pix; 
curr_pic=zeros(N,M);
imshow(curr_pic);

% get location of the mouse relative to the displayed image!
C = get (gca, 'CurrentPoint');

x = min(M,max(1, round(C(1,1))));
y = min(N,max(1, round(C(1,2))));
show_x = max(1,x-ceil(L/2)) : min(M, x+ceil(L/2));
show_y = max(1,y-ceil(L/2)) : min(N, y+ceil(L/2));

Sampled_Mat=Phosphane_the_image(pic(show_y,show_x),Num_pix,Org);
curr_pic(show_y,show_x) = Sampled_Mat(:,:);

imshow(curr_pic);
% set(gcf,'Position',get(0,'Screensize'))%enlarge image to full screen
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);

end