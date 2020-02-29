I=imread('train_0001.png');


T=graythresh(I);
BW = I < T * max(I(:));

%Closing gaps
subplot(2,4,1)
imshow(BW);
title('Original');
BW2 = bwareaopen(BW,100);
subplot(2,4,2);
imshow(BW2);
title('bwareopen');

%RGB label
se = strel('disk', 1);
BW2= imerode(BW2, se);
se = strel('disk', 1);
BW2 = imdilate(BW2, se);
LabeledImg = bwlabel(BW2, 8);
ColoredLabels = label2rgb(LabeledImg, 'spring', 'k', 'shuffle');
subplot(2,4,3);
imshow(ColoredLabels);
title('Colored labels');


%Distance Transform

DistImg = -bwdist(~BW2);
subplot(2,4,4)
imshow(mat2gray(DistImg));
title('Distance transform');

%fixing over segmentation
mask = imextendedmin(DistImg,2);
D2=imimposemin(DistImg,mask);


% Removing small regions which are mostlikely not coins:
WS = watershed(D2);
se = strel('disk', 1);
WS = imerode(WS, se);
WS = imdilate(WS, se);
WS(~BW2) = 0;
subplot(2,4,5);
imagesc(WS);
title('Water transform');

%Dividing areas
F = regionprops(BW2, 'all');
Areas = [F.Area];

fprintf('Numbers %d\n', sum(Areas(:) > 0));

subplot(2, 4, 7:8);
hist(Areas);
title('Areas');

