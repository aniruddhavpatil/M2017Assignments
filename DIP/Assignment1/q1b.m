I=imread('./Assign1_imgs/hist_equal4.jpg');
J = I;
sz = size(J);
N = 100;
M = 100;
normalize = 1 / M / N;
% 
% modx = mod(sz(2),N);
% padx = zeros(sz(1),N - modx + 1);
% if modx > 0
%     J = [J, padx];
% end
% 
% mody = mod(sz(1),M);
% pady = zeros(M - mody + 1 , size(J,2));
% J = [J;pady];

for k = 1:N:sz(1)-N
    for l = 1:M:sz(2)-M
        I = J(k : k+N ,l : l+M);
        h = zeros(1,256);
        for i= 1:size(I,1)
            for j= 1:size(I,2)
                val = I(i,j) + 1;
                h(val) = h(val) + normalize;
            end
        end

        sum = 0.0;

        lookup = zeros(1,256);

        for i = 1:256
            sum = sum + h(i);
            lookup(i) = sum * 255 + 0.5;
        end

        for i= 1:size(I,1)
            for j= 1:size(I,2)
                I(i,j) = lookup((I(i,j) + 1));
            end
        end
        J(k:k+N,l:l+M) = I;
    end
end

imshow(J);