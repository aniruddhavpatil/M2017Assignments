I = imread('./Assign2_imgs/notch_pass_reject_filter/notch2.jpg');
% I1 = rgb2gray(I);
I1 = im2double(I);
Ift = fft2(I);
Ift = fftshift(Ift);
Iift = mat2gray(log(1+abs(Ift)));

Ift(37:44,107:108)=0;
Ift(40:41,105:110)=0;

Ift(89:90,20:25)=0;
Ift(85:95,22:23)=0;

Ift(77,80:92) =0;
Ift(71:83,86)= 0;

Ift(53,38:50) = 0;
Ift(47:59,44) = 0;

Ift(8:12,22:23) = 0;
Ift(120:124,22:23) = 0;

Ift(6:10,107:108)=0;
Ift(118:122,107:108)=0;

ansI = ifft2(ifftshift(Ift));
Ift = mat2gray(log(1+abs(Ift)));
ansI=mat2gray(abs(ansI));
subplot(1,4,1); imshow(I);
subplot(1,4,2); imshow(Iift);
subplot(1,4,3); 
imshow(Ift);
subplot(1,4,4); 
imshow(ansI);
