I = imread('./Assign1_imgs/stereo_pair.jpg');
split = size(I,2)/2;

I1 = I(:, 1:split -9 , :);
I2 = I(:,split + 10: size(I,2), :);

% imshow(I1);
% [x,y] = getpts;
% pts1 = [x,y];
% 
% imshow(I2);
% [x,y] = getpts;
% pts2 = [x,y];
PH = [];
B = [];
for i = 1:4
    p1 = [-pts1(i,1),-pts1(i,2), -1, 0,0,0, pts1(i,1)*pts2(i,1), pts1(i,2)*pts2(i,1)];
    p2 = [0,0,0,-pts1(i,1),-pts1(i,2), -1, pts1(i,1)*pts2(i,2) , pts1(i,2)*pts2(i,2)];
    p = [p1;p2];
    PH = [PH ; p];
    B = [B ; pts2(i,1); pts2(i,2)];
end
% B = zeros(8,1);
h = inv(PH) * B;
h = [h;1];
H = reshape(h, [3,3]);

F = zeros(size(I1,1), size(I1,2));
t = maketform('projective',H);
F = imtransform(I1,t);
F = flipud(F);
F = fliplr(F);

F = I1 - imresize(F,[size(I2,1),size(I2,2)]);

imshow(F);
