I = imread('./Assign1_imgs/bell.jpg');

% Median---------------------------------------------------

 fsz = 3;
 disp = floor(fsz / 2);
 I = rgb2gray(I);
 mFiltered = I;
 I = padarray(I, [floor(fsz/2) floor(fsz/2)]);
 h = size(I,1);
 w = size(I,2);
     for i=1+disp:h-disp
         for j=1+disp:w-disp
             box = I(i-disp:i+disp, j-disp:j+disp);
             box = reshape(box, [1,fsz*fsz]);
            medval = median(box);
           mFiltered(i, j) = medval;
        end
     end
imshow(mFiltered);