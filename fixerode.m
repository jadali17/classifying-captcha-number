
I=imread('train_0001.png');
comp = imcomplement(I);
NoiseReduced = comp;
NoiseReduced = medfilt2(comp, [5 5]);
se = strel('disk', 2, 0);
NoiseReduced = imerode(NoiseReduced, se);
NoiseReduced = imdilate(NoiseReduced, se);
imshow(NoiseReduced)