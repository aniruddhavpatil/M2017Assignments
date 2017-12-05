clear;
im = rgb2gray(imread('./Assign4_imgs/Uncompressed_02.BMP'));

c = 1;

qm = double([16 11 10 16  24  40  51  61
            12 12 14 19  26  58  60  55
            14 13 16 24  40  57  69  56
            14 17 22 29  51  87  80  62
            18 22 37 56  68 109 103  77
            24 35 55 64  81 104 113  92
            49 64 78 87 103 121 120 101
            72 92 95 98 112 100 103 99]);

N = 8;
dct_mat = zeros(N,N);
r0 = sqrt(1/N);
r1 = sqrt(2/N);

for v=0:N-1
    for u=0:N-1
        if v == 0
            dct_mat(v+1,u+1) = r0*cos((pi*(2*u+1)*v)/(2*N));
        else
            dct_mat(v+1,u+1) = r1*cos((pi*(2*u+1)*v)/(2*N));
        end
    end
end

quantize = @(block_struct) (block_struct.data ./ (c*double(qm)));

toDCT = double(im);
toDCT = toDCT - 128;
F = dct_mat
dct = @(block_struct) F * block_struct.data * F';
im_dct = blockproc(toDCT, [8 8], dct);
im_dct = double(im_dct)
im_dct_quantized = blockproc(im_dct, [8 8], quantize);

im_dct = round(im_dct_quantized);

dequantize = @(block_struct) (block_struct.data .* (c*double(qm)));
im_dct_dequantized = blockproc(double(im_dct), [8 8], dequantize);

inv_dct = @(block_struct) F' * block_struct.data * F;
im_idct = blockproc(double(im_dct_dequantized),[8 8],inv_dct);
im_idct = round(im_idct);
im_idct = im_idct + 128;
im_dct = round(im_idct);


Q = zeros(8,8);

temp = ones(1,8);

Q(1:8,1) = temp
Q(1,1:8) = temp
Q(8,1:8) = temp
Q(8,1:8) = temp

dft = @(block_struct) ifft2(Q.*(fft2(block_struct.data)));

im_dft = blockproc(double(im), [8 8], dft);

[LL,LH,HL,HH] = dwt2(im,'haar');

threshold = 70;
LL = LL.*(LL > threshold);
LH = LH.*(LH > threshold);
HL = HL.*(HL > threshold);
HH = HH.*(HH > threshold);

im_dwt = idwt2(LL,LH,HL,HH,'haar',size(im));

imshow([im,im_dct;im_dft,im_dwt])

RMSE_dct = sqrt(mean(mean((double(im)-double(im_dct)).^2,2),1));
RMSE_dft = sqrt(mean(mean((double(im)-double(abs(im_dft))).^2,2),1));
RMSE_dwt = sqrt(mean(mean((double(im)-double(im_dwt)).^2,2),1));

RMSE_dct,RMSE_dft,RMSE_dwt
