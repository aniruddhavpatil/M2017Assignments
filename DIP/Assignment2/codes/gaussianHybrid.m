function [ imx ] = gaussianHybrid(image,arg)
    im1 = rgb2gray(image);
    f = fftshift(fft2(im1));
    sig = 10;
    [H, W] = size(f);
    [x, y] = meshgrid(1:W, 1:H);
    c1 = floor(W/2);
    c2 = floor(H/2);
    dist = (x - c1).^2 + (y - c2).^2;
    if arg == 0
        filter = exp(-1 * dist / (2 * sig^2));
    else
        filter = 1 - exp(-1 * dist / (2 * sig^2));
    end
    f = f.*filter;
    imx = ifft2(ifftshift(f));
    imshow(uint8(abs(imx)));
end
