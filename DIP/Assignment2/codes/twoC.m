I = imread('Assign2_imgs/other_images/concordaerial.png');
[m,n,d3] = size(I);
filt = ones(m,n);
for i=1:m
    for j=1:n
      x = (i-floor(m/2));
      y = (j-floor(n/2));
       filt(i,j) =  -(x^2 + y^2);
    end
end
fin = ones(size(I));
for i=1:3
    Ift = fftshift(fft2(I(:,:,i)));
    ans = Ift.*filt;
    Iift = ifftshift(ans);
    ans = abs(ifft2(Iift));
    myMax = max(-1*ans);
    myMax = max(myMax);
    ans = ans/myMax*255;
    fin(:,:,i)=I(:,:,i)+uint8(ans);

end
imshow(uint8(fin))
