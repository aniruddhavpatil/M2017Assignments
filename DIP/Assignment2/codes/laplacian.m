function l = laplacian(im,level)
    imArr = gaussian(im,level);
    hp = cell(1,level);
    imArr = imArr{1};

    for i = level:-1:2
        y = imArr{i - 1};
        x = imArr{i};
        imFinal = imresize(x,[size(y,1) size(y,2)]);
        hp{i - 1} = y - imFinal;
    end
    hp{level} = imArr{level};

    l = hp;
end
