function ans = q2(img)

img = double(rgb2gray(img));

[h,w] = size(img);
h = h-3;
w = w-3;
varCoef = 0.0085;
meanCoef = 1.265;
meanGlob = mean(mean(img(:,:)));

for i=1:h
    for j=1:w
            imTemp=img(i:i+2,j:j+2);
            varTemp=var(var(imTemp(:,:)));
            Txy(j) = varCoef*varTemp+ meanCoef*meanGlob;
            if(Txy(j)>255)
              if(j~=1)
                Txy(j)=Txy(j-1);
              end
            end

            if (img(i,j)<=Txy(j))
                out(i,j) = 0;
            else
                out(i,j) = 1;
            end
        end
end

imshow(out);

end
