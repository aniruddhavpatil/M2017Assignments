I = imread('./Assign2_imgs/notch_pass_reject_filter/notch3.jpg');
I1 = im2double(I);
Ift = I1;
ansI = I1;
Ift(:,:,1) = fft2(I(:,:,1));
Ift(:,:,2) = fft2(I(:,:,2));
Ift(:,:,3) = fft2(I(:,:,3));

Ift(:,:,1) = fftshift(Ift(:,:,1));
Ift(:,:,2) = fftshift(Ift(:,:,2));
Ift(:,:,3) = fftshift(Ift(:,:,3));

Iift = mat2gray(log(1+abs(Ift)));

Ift(1:88,128:132,:) = 0;
Ift(170:256, 128:132,:) = 0;

Ift(128:132,1:88,:) = 0;
Ift(128:132,170:256,:) = 0;

ansI(:,:,1) = ifft2(ifftshift(Ift(:,:,1)));
ansI(:,:,2) = ifft2(ifftshift(Ift(:,:,2)));
ansI(:,:,3) = ifft2(ifftshift(Ift(:,:,3)));

Ift = mat2gray(log(1+abs(Ift)));
ansI=mat2gray(abs(ansI));
subplot(1,4,1); imshow(I);
subplot(1,4,2); imshow(Iift(:,:,1));
subplot(1,4,3);
imshow(Ift(:,:,1));
subplot(1,4,4);
imshow(ansI);
