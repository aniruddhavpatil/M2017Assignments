function im = blend(im1,im2,mask,level)
    im1 = im2double(im1);
    im2 = im2double(im2);

    mask = mask / 255;
    g = gaussian(mask,level);
    g = g{1};
    blend = cell(1,level);

    l1 = laplacian(im1,level);
    l2 = laplacian(im2,level);
    for i = level:-1:1
        temp = mat2gray(g{i});
        i1 = l1{i};
        i2 = l2{i};
        i2(:,:,1) = i2(:,:,1) .* temp;
        i2(:,:,2) = i2(:,:,2) .* temp;
        i2(:,:,3) = i2(:,:,3) .* temp;

        i1(:,:,1) = i1(:,:,1) .* (1 - temp);
        i1(:,:,2) = i1(:,:,2) .* (1 - temp);
        i1(:,:,3) = i1(:,:,3) .* (1 - temp);
        x = i1 + i2;
        blend{i} = x;
    end

    for i = level:-1:2
        t0 = blend(1,i);
        t1 = blend(1,i - 1);
        t0 = cell2mat(t0);
        t1 = cell2mat(t1);
        t0 = imresize(t0, [size(t1,1) size(t1,2)]);
        blend{i-1} = t1 + t0;
    end
    
    imshow(blend{1});
end
