function output = gaussian(im,level)
    fs = 10;
    sig = 100;

    gauss = zeros(fs,fs);
    for i = 1:fs
        for j = 1:fs
            gauss(i,j) =  exp(-(abs(fs - i)^2 + abs(fs - j)^2) / (2*sig*sig));
        end
    end

    N = sum(gauss(:));
    gauss = gauss / N;
    hp = cell(1,level);
    imArr = cell(1,level);
    imFinal = im;

    for i = 1:level
        imTemp = imFinal;

        imArr{i} = imFinal;
        imFinal = imfilter(imFinal, gauss);
        hp{i} = imTemp - imFinal;
        imFinal = imFinal(1:2:end, 1:2:end,:);
    end
    output = {imArr,hp};
end
