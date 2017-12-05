function oneNearest

img = imread('./Assign2_imgs/other_images/pears.png');

height = size(img, 1);
width = size(img, 2);
ht2 = height * 2;
wid2 = width * 2;

x = zeros(ht2, wid2,3);
x = x - 1;

x(1:2:ht2, 1:2:wid2,1) = img(1:height, 1:width,1);
x(1:2:ht2, 1:2:wid2,2) = img(1:height, 1:width,2);
x(1:2:ht2, 1:2:wid2,3) = img(1:height, 1:width,3);


for i = 1 : ht2
    for j = 1 : wid2        
        if x(i, j, 1) == -1            
            if mod(i, 2) == 0
                x(i, j, :) = x(i - 1, j,:);
            else
                x(i, j, :) = x(i, j - 1,:);
            end 
        end        
    end
end

img = x;

imshow(uint8(x));
end