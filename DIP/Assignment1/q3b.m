xc=[500,250,750,100,250];
yc=[250,750,500,200,500];
% rmax=[200,300,400,500,600];
rmax = [200,250,300,350,400];
rho=[0.5,3,4,5,6];

I = imread('./Assign1_imgs/portraits2.jpg');
for l = 1:5
    im = zeros(size(I,1), size(I,2),3);
    N = size(im,1);
    M = size(im,2);
    for i = 1:N
        for j=1:M
            
            dx = i - xc(l);
            dy = j - yc(l);
            r = sqrt(dx^2 + dy^2);
            z = sqrt(rmax(l)^2 - r^2);
            betaX = (1 - 1/rho(l)) * asin(dx/sqrt(dx^2 + z^2));
            betaY = (1 - 1/rho(l)) * asin(dy/sqrt(dy^2 + z^2));
            
            delX = z*tan(betaX);
            delY= z*tan(betaY);
            
            if r > rmax(l);
                delX = 0;
                delY = 0;
            end
            x = i - int16(round(delX));
            y = j - int16(round(delY));
            
            x = min(N,x);
            x = max(1,x);
            y = min(M,y);
            y = max(1,y);
            im(i,j,:) = I(x,y,:);
        end
    end
%     imshow(uint8(im));
     imwrite(uint8(im),['threeb3',num2str(l),'.png']);
end