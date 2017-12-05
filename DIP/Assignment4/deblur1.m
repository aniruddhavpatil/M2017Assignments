len = 30;
theta = 0;
nsr = .03;

I = imread('Assign4_imgs/restore_01.jpg');

psf = fspecial('motion', len, theta);

restored = deconvwnr(I, psf, nsr);
restored = uint8(restored);
imwrite(restored, 'restored01.jpg');
