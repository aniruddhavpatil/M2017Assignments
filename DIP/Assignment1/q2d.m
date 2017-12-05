I = imread('Assign1_imgs/portraits.jpg');

sigma = 10;
fsz = 8;

I = im2double(I);
least = floor(fsz/2);
I2 = padarray(I, [least least]);
blFiltered = I;
for i = 1 + least: size(I2,1) - least
    for j = 1 + least: size(I2,2) - least
        box = I2(i - least: i + least, j - least: j + least, :);

        gf = zeros(fsz,fsz);

        for k = 1:fsz
          for l = 1:fsz
            gf = exp(-(abs(fsz - k)^2 + abs(fsz -l)^2) / (2*sigma*sigma));
          end
        end

        diff = [];
        for c = 1:3
          diff =[diff; box(:,:,c) - I2(i,j,c)];
        end

        H = exp(-(diff(1).^2+diff(2).^2+diff(3).^2)/(2*(sigma^2)));

        N = gf .* H;
        N = sum(sum(N(:)));
        for c = 1:3
        temp(:, :, c) = box(:, :, c) .* H;
        temp(:, :, c) = temp(:, :, c) .* gf;
        temp(c) = sum(sum(temp(:, :, c)));
        final(c) = temp(c) / N;
        end

        blFiltered(i, j, :) = final(:);

    end
end

imshow(uint8(blFiltered));
