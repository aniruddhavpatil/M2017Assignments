function [ imx ] = butterworthHybrid(image,arg)
    im1 = rgb2gray(image);
    f = fftshift(fft2(im1));
    radius = 10;
    n = 5;
    [H, W] = size(f);
    [x, y] = meshgrid(1:W, 1:H);
    c1 = floor(W/2);
    c2 = floor(H/2);
    dist = (x - c1).^2 + (y - c2).^2;
    filter = 1 + (dist / radius^2) .^ n;
    if arg == 1
        filter = 1 + (radius^2 ./ dist) .^ n;
    end
    filter = 1 ./ filter;
    f = f.*filter;
    imx = ifft2(ifftshift(f));
    imshow(uint8(abs(imx)));
end
