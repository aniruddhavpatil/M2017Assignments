function [ ans ] = fft2d( path )

path = 'Assign2_imgs/other_images/cameraman.tif';

I = imread(path)
[R, C] = size(I);
im = im2double(I);
R = pow2(round(log2(R)));
C = pow2(round(log2(C)));
arr = imresize(im, [R C]);
temp = zeros(size(arr));
ans = zeros(size(arr));
for i = 1:R
    temp(i,:) = fft1d(arr(i,:), exp(-2*1i*pi/C));
end
for j = 1:C
    first = transpose(temp(:,j));
    second = transpose(exp(-2*1i*pi/R));
    ans(:,j) = fft1d(first, second);
end
final = mat2gray(log(1 + abs(ans)))
imshow(final);
end
