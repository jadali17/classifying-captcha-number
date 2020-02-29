I=imread('train_0029.png');
h = [1 0 1];

q=double(I);
q=(~imfilter(q,h,'conv'))
imtool(q);


T=graythresh(I);
BW = I < T * max(I(:));

%Cleaning up the image
subplot(2,4,1)
imshow(BW);
title('Original');
BW2 = bwareaopen(BW,100);
BW3= medfilt2(BW2);;
subplot(2,4,2);
imshow(BW3);
title('Threshholded');

% Removing noises (bright pixels on coins):


se = strel('disk', 1);
BW3 = imerode(BW3, se);
se = strel('disk', 1);
BW3 = imdilate(BW3, se);



%RGB label
LabeledImg = bwlabel(BW3, 8);
ColoredLabels = label2rgb(LabeledImg, 'spring', 'k', 'shuffle');
subplot(2,4,3);
imshow(ColoredLabels);
title('Colored labels');


%Distance Transform
DistImg = bwdist(~BW3,'cityblock');
subplot(2,4,4)
imshow(mat2gray(DistImg));
title('Distance transform');

se = strel('disk', 1);
WS = imerode(DistImg, se);
WS = imdilate(DistImg, se);
WS = watershed(- DistImg);
WS(~BW3) = 0;

% Removing small regions which are mostlikely not coins:
se = strel('disk', 1);
WS = imerode(WS, se);
WS = imdilate(WS, se);

subplot(2,4,5);
imagesc(WS);
title('Water transform');

F = regionprops(BW3, 'all');
Areas = [F.Area];

fprintf('Numbers %d\n', sum(Areas(:) > 0));

subplot(2, 4, 7:8);
hist(Areas);
title('Areas');
