function CNew = ScaleImage(levelname,scale)

% Rescale an image in two dimensions independently.
%
% CNew = ScaleImage(levelname,scale)
%
% INPUTS:
% -levelname is a string that indicates an image filename in the current
% path.
% -scale is a 2-element vector indicating the number of pixels in a single
% unit of distance (in the x and y directions).  If the number is negative,
% the image will be flipped in that direction.
%
% OUTPUTS:
% -CNew is an image matrix containing the newly scaled image.  It can be 
% saved using imwrite.
%
% Created 4/18/11 by DJ.

% load image
C = imread(levelname);
% plot image
subplot(1,2,1)
imagesc(C);
axis image
set(gca,'ydir','normal');
hold on;
% overlay scale bars
plot([1,1], [1, 1+scale(2)*10],'g');
plot([1,1+scale(1)*10], [1, 1],'g');

% create new image using imresize
CNew = imresize(C,[size(C,1)/abs(scale(1)), size(C,2)/abs(scale(2))],'nearest');

% flip image if necessary
if scale(1)<0
    for i=1:size(CNew,3)
        CNew(:,:,i) = fliplr(CNew(:,:,i));
    end
end
if scale(2)<0
    for i=1:size(CNew,3)
        CNew(:,:,i) = flipud(CNew(:,:,i));
    end
end
    
% plot new image
subplot(1,2,2)
imagesc(CNew);
axis image
set(gca,'ydir','normal');
hold on;
% overlay scale bars
plot([1,1], [1, 1+10],'g');
plot([1,1+10], [1, 1],'g');