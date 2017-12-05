ax = [5,5,10,20,20];
ay = [5,5,20,10,10];
tx = [10,100,200,100,500];
ty = [10,200,100,100,500];

I = imread('./Assign1_imgs/bell.jpg');
for l = 1:5
    im = zeros(size(I,1), size(I,2),3);
    N = size(im,1);
    M = size(im,2);
    for i = 1:N
        for j=1:M
            x = i + int16(round(ax(l)*sin(2*pi*j/tx(l))));
            y = j + int16(round(ay(l)*sin(2*pi*i/ty(l))));
    %         [i,j,x,y]
            x = min(N,x);
            x = max(1,x);
            y = min(M,y);
            y = max(1,y);
            im(i,j,:) = I(x,y,:);
        end
    end
    imwrite(uint8(im),['three3',num2str(l),'.png']);
end