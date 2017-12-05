function ans = detectparabola(img)

rvals = [0.003,0.004,0.005,0.006,0.007,0.008];

I=rgb2gray(img);


[N,M]=size(I);

A=zeros(N,M,R);

[E,thresh]=edge(I,'canny',0.25);
[yindex xindex]=find(E);

y0detect = [];
x0detect= [];

thresh = 100;

r0detect= [];

R=length(rvals);
for cnt=1:length(xindex)
    for r=1:R
        for x0=1:M
            del = rvals(r)*(xindex(cnt)-x0)^2;
            y0=round(yindex(cnt)-del);
            if( (y0 < N) && (y0>=1))
                A(y0,x0,r) = A(y0,x0,r)+1;
            end
        end
    end
end

Amax=imdilate(max(A,[],3),strel('disk',40));


for r=1:R
    [y0 x0]=find((Amax(:,:) == A(:,:,r)) & ...
      A(:,:,r) > thresh);
    temp = ones(length(x0,1));
    r0detect=[r0detect; rvals(r)*temp];

    y0detect=[y0detect; y0];
    x0detect=[x0detect; x0];
end

subplot(1,2,1);
imshow(I,[]);

subplot(1,2,2);
imshow(E,[]);

for i=1:length(x0detect)
    x0=x0detect(i);
    y0=y0detect(i);
    r0=r0detect(i);
    for x=1:M
        delX = (x-x0); 
        y=y0+r0*delX^2;
        y=round(y);
        if y<=N & y>=1
            rectangle('Position',[x y 1 1],'Edgecolor','r');
        end
    end
end

ans = E;

end
