I=rgb2gray(imread('./Assign1_imgs/hist_equal.jpg'));
% I = imread('./Assign1_imgs/hist_equal4.jpg');
I1 = rgb2gray(imread('./Assign1_imgs/hist_equal3.jpg'));
sz = size(I);
N = sz(1);
M = sz(2);

normalize = 1 / M / N;

h1 = zeros(1,256);
for i= 1:N
    for j= 1:M
        val = I(i,j) + 1;
        h1(val) = h1(val) + normalize;
    end
end

h2 = zeros(1,256);
for i= 1:size(I1,1)
    for j= 1:size(I1,2)
        val = I1(i,j) + 1;
        h2(val) = h2(val) + normalize;
    end
end

cdf1 = cumsum(h1) / numel(I); 
cdf2 = cumsum(h2) / numel(I1);

sum = 0.0;

lookup = zeros(1,256);

for i = 1:256
%     sum = sum + h(i);
%     lookup(i) = sum * 255 + 0.5;
      [~,ind] = min(abs(cdf1(i) - cdf2));
      lookup(i) = ind -1;
end

sz = size(I);
N = sz(1);
M = sz(2);

for i = 1:N
    for j = 1:M
        I(i,j) = lookup((I(i,j) + 1));
    end
end
        
imshow(uint8(I));


