len = 25;
theta = -15;
nsr = .025;

I = imread('Assign4_imgs/restore_04.jpg');

psf = fspecial('motion', len, theta);

restored = deconvwnr(I, psf, nsr);
restored = uint8(restored);
imwrite(restored, 'restored04.jpg');
