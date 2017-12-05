function ans = circles(im)
voteThreshold=180;

im=rgb2gray(im);
im=edge(im,'canny');
im=255*double(im);


[M N]=size(im);
voteArray=zeros(M,N,100);
final=zeros(M,N);

for i=1:M
    for j=1:N
        if(im(i,j)==255)
            for r=10:100
                for theta=0:360
                    a= i-r*cos(theta*pi/180);
                    b=j-r*sin(theta*pi/180);
                    a = floor(a);
                    b = floor(b);
                    if(a>=1 && b>=1)
                      if(a<=M && b<=N)
                        voteArray(a,b,r)=voteArray(a,b,r)+1;
                      end
                    end
                end
            end
        end
    end
end

k=1;
for i=1:M
    for j=10:N
        for r=1:100
            if( voteThreshold < voteArray(i,j,r))
                store(k,1)=i;
                store(k,2)=j;
                store(k,3)=r;
                for theta=0:360
                    a=i-r*cos(theta*pi/180);
                    b=j-r*sin(theta*pi/180);
                    a = floor(a);
                    b = floor(b);
                    if(a>=1 && b>=1)
                      if(a<=M && b<=N)
                        final(a,b)=255;
                      end
                    end
                end
                k=k+1;
            end
        end
    end
end
imshow(uint8(final));
ans = uint8(final);
end
