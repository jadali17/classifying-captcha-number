c=cell(1,4);
objects={};
for i=1:1
c{i}=imread(sprintf('train_%04d.png',i));

T=graythresh(im);
processed_img = im < T * max(im(:));
se = strel('disk', 1);
processed_img= imerode(processed_img, se);
% processed_img = bwareaopen(processed_img,100);
imshow(processed_img)



% I=imread('train_0083.png');

%-------PREPROCESSING-------%
%THRESHOLDING
T=graythresh(c{i});
BW = c{i} < T * max(c{i}(:));
%             subplot(2,4,1)                %plotting
%             imshow(BW);
se = strel('disk', 1);
BW= imerode(BW, se);
BW2 = bwareaopen(BW,100);
%             subplot(2,4,2);               %plotting
%             imshow(BW2);
%             title('bwareopen');
%LABELING
se = strel('disk', 1);
BW2 = imdilate(BW2, se);
LabeledImg = bwlabel(BW2, 8);

ColoredLabels = label2rgb(LabeledImg, 'spring', 'k', 'shuffle');

%--------DIGIT EXTRACTION--------%
s = regionprops(BW2, 'BoundingBox');
bb = round(reshape([s.BoundingBox], 4, []).');
% imshow(BW2);                                %plotting
for idx = 1 : numel(s)
    rectangle('Position', bb(idx,:), 'edgecolor', 'red');
end

chars = cell(1, numel(s));
for idx = 1 : numel(s)
    chars{idx} = BW2(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
end


 end

for i = 1:3
subplot(100,100,i)
imshow(objects{i});
end





% BW3 = bwareafilt(BW2,[400 500]);

% subplot(2, 4, 3);
% imshow(I);
% title('Outlines, from bwboundaries()', 'FontSize', captionFontSize); 
% axis image; % Make sure image is not artificially stretched because of screen's aspect ratio.
% hold on;
% boundaries = bwboundaries(BW2);
% numberOfBoundaries = size(boundaries, 1);
% for k = 1 : numberOfBoundaries
% 	thisBoundary = boundaries{k};
% 	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
% end
% hold off;
% subplot(2,4,3);
% % imshowpair(BW2,BW3,'montage')
% imshow(ColoredLabels);
% title('Colored labels');
% 
% %Distance Transform
% se = strel('disk', 1);
% BW2= imerode(BW2, se);
% DistImg = -bwdist(~BW2);
% subplot(2,4,4)
% imshow(mat2gray(DistImg));
% title('Distance transform');
% 
% %fixing over segmentation
% mask = imextendedmin(DistImg,2);
% D2=imimposemin(DistImg,mask);
% 
% 
% % Removing small regions which are mostlikely not coins:
% WS = watershed(D2);
% se = strel('disk', 1);
% WS = imerode(WS, se);
% WS = imdilate(WS, se);
% WS(~BW2) = 0;
% subplot(2,4,5);
% imagesc(WS);
% title('Water transform');
% 
% %Dividing areas
% F = regionprops(BW2, 'all');
% Areas = [F.Area];
% 
% fprintf('Numbers %d\n', sum(Areas(:) > 0));
% 
% subplot(2, 4, 7:8);
% hist(Areas);
% title('Areas');
% 
% end