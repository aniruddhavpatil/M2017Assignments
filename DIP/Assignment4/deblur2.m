len = 25;
theta = 0;
nsr = .035;

I = imread('Assign4_imgs/restore_02.jpg');

psf = fspecial('motion', len, theta);

restored = deconvwnr(I, psf, nsr);
restored = uint8(restored);
imwrite(restored, 'restored02.jpg');
