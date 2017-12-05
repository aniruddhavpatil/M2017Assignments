I = imread('./Assign1_imgs/bell.jpg');

% Gauss-----------------------------------------------------------
fsz = [3,5,8];
sigma = [1,2,3];

for q=1:3

gf = zeros(fsz(q),fsz(q));
for i = 1:fsz(q)
    for j = 1:fsz(q)
        gf(i,j) =  exp(-(abs(fsz(q) - i)^2 + abs(fsz(q) - j)^2) / (2*sigma(q)*sigma(q)));
    end
end

total = 0;
for i = 1:size(gf,1)
    for j = 1:size(gf,2)
        total = total + gf(i,j);
    end
end
        
gf = gf / total;
gFiltered = imfilter(I, gf);
 
% imshow(uint8(gFiltered));

%High-------------------------------
mask = 0.8;
sharp = I - gFiltered;
hbFiltered = I + mask .* sharp;
% imshow(hbFiltered);

imwrite([gFiltered,hbFiltered], ['gaussHigh',num2str(q),'.png']);
end



