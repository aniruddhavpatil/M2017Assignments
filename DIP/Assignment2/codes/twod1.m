I = imread('./Assign2_imgs/notch_pass_reject_filter/notch1.png');
% I1 = rgb2gray(I);
I1 = im2double(I);
Ift = fft2(I);
Ift = fftshift(Ift);
Iift = mat2gray(log(1+abs(Ift)));

Ift(20:90,136:137) = 0;
Ift(20:90,172:173) = 0;
Ift(77:82,134:139) = 0;
Ift(77:82,171:174) = 0;
Ift(79:80,20:145) = 0;
Ift(79:80,165:300) = 0;


Ift(170:220,150:151) = 0;
Ift(170:220,185:186) = 0;
Ift(176:181,148:153) = 0;
Ift(176:181,183:188) = 0;
Ift(178:179,50:157) = 0;
Ift(178:179,175:300) = 0;


Ift(1:84,161:162) = 0;
Ift(165:256,161:162) = 0;

ansI = ifft2(ifftshift(Ift));
Ift = mat2gray(log(1+abs(Ift)));
ansI=mat2gray(abs(ansI));
subplot(1,4,1); imshow(I);
subplot(1,4,2); imshow(Iift);
subplot(1,4,3); imshow(Ift);
subplot(1,4,4); imshow(ansI);
