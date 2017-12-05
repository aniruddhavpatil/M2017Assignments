len = 20;
theta = 30;
nsr = .025;

[I, map] = imread('Assign4_imgs/restore_03.gif');
I = ind2rgb(I, map);

psf = fspecial('motion', len, theta);

restored = deconvwnr(I, psf, nsr);
imwrite(restored, 'restored03.jpg');
