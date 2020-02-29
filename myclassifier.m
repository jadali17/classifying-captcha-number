function S = myclassifier(im)

Digits = {};
count = 0;

%----PreProcessing,Segmentation-----%
T=graythresh(im);
processed_img = im < T * max(im(:));
se = strel('disk', 1);
processed_img= imerode(processed_img, se);

processed_img=  bwareaopen(processed_img,100);


%-------Labeling-------%
[Object_label, object] = bwlabel(processed_img);
for i = 1:object
    [row, col] = find(Object_label == i);
        digit = processed_img(min(row):max(row), min(col):max(col));
        count = count + 1;
        Digits{count} = digit;
end
if count < 2
        [r, c] = size(Digits{1});
        Digits{3}=  Digits{1}(:, uint8(2*c/3):c); 
        Digits{2} = Digits{1}(:, uint8(c/3):uint8(2*c/3));        
        Digits{1} = Digits{1}(:, 1:uint8(c/3));
end
if count == 2
    if length(Digits{1}) > length(Digits{2})
        Digits{3} = Digits{2};
        [r, c] = size(Digits{1});
        Digits{2} = Digits{1}(:, uint8(c/2):c);        
        Digits{1} = Digits{1}(:, 1:uint8(c/2));
    else
        [r, c] = size(Digits{2});
        Digits{3} = Digits{2}(:, uint8(c/2):c);        
        Digits{2} = Digits{2}(:, 1:uint8(c/2));
    end
end


%--------Extracting the classes-------%
C=imread('train_0023.png')


       %----------Preprocessing----------%
       T=graythresh(C);
       bw = C < T * max(C(:));
       se = strel('disk', 1);
       bw= imerode(bw, se);
       bw=  bwareaopen(bw,100);
       
c = regionprops(bw, 'BoundingBox');
bb = round(reshape([c.BoundingBox], 4, []).');
for idx = 1 : numel(c)
    rectangle('Position', bb(idx,:), 'edgecolor', 'red');
end

chars = cell(1, numel(c));
for idx = 1 : numel(c)
    chars{idx} = bw(bb(idx,2):bb(idx,2)+bb(idx,4)-1, bb(idx,1):bb(idx,1)+bb(idx,3)-1);
end

d1=chars{1};
d0=chars{2};
d2=chars{3};
%------Classification-------%

S = [0 0 0];
for i = 1:3
    img = Digits{i}
    if length(img) > 0
        d0 = imresize(d0, size(img));
        add0 = img + d0;
        d1 = imresize(d1, size(img));
        add1 = img + d1;    
        d2 = imresize(d2, size(img));
        add2 = img + d2;    
        
        if sum(add1(:) == 2) > sum(add0(:) == 2) && sum(add1(:) == 2) > sum(add2(:) == 2)
            S(i) = 1;
        end
        if sum(add2(:) == 2) > sum(add1(:) == 2) && sum(add2(:) == 2) > sum(add0(:) == 2)
            S(i) = 2;
        end
    end
end
