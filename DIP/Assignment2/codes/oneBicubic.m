img = imread('./Assign2_imgs/other_images/football.jpg');

height = size(img, 1);
width = size(img, 2);
ht2 = height * 2;
wid2 = width * 2;

x = zeros(ht2, wid2,3);
x = x - 1;

x(1:2:ht2, 1:2:wid2,1) = img(1:height, 1:width,1);
x(1:2:ht2, 1:2:wid2,2) = img(1:height, 1:width,2);
x(1:2:ht2, 1:2:wid2,3) = img(1:height, 1:width,3);

for i = 1: 2: ht2
    for j = 1: wid2
        if x(i, j,1) == -1
            if j <= 4
                x(i, j,:) = floor((x(i, j - 1, :) + x(i, j + 1, :)) / 2);
            elseif j >= wid2 - 4
                x(i, j, :) = x(i, j - 1, :);

            else
                for c = 1:3
                    x(i, j, c) = floor(solver(x(i, j - 3, c), x(i, j - 1, c), x(i, j + 1, c), x(i, j + 3, c), j - 1, j + 1));
                end
            end
        end
    end
end

for i = 2: 2: ht2
    for j = 1: wid2

        if i <= 4
            x(i, j,:) = floor((x(i - 1, j,:) + x(i + 1, j,:)) / 2);
        elseif i >= ht2 - 4
            x(i, j,:) = x(i - 1, j,:);

        else
            for c = 1:3
                x(i, j,c) = floor(solver(x(i - 3, j,c), x(i - 1, j,c), x(i + 1, j,c), x(i + 3, j,c), i - 1, i + 1));
            end
        end

    end
end

dup = img;
dup(:) = 0;
x=uint8(x);
y = [dup,dup;dup,img];
imshow([y,x]);

