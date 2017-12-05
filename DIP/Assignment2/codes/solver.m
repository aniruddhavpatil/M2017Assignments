function ans = solver(p0, p1, p2, p3, x1, x2)

r1 = [x1^3 x1^2 x1 1];
r2 = [x2^3 x2^2 x2 1];
r3 = [3*(x1^2) 2*x1 1 0];
r4 = [3*(x2^2) 2*x2 1 0];

M = [r1;r2;r3;r4];

Y = [p1; p2; (p1 - p0)/2; (p3 - p2)/2;];

[U,S,V] = svd(M);

c = V * inv(S) * U' * Y;

pt = (x1 + x2)/2;

ans = 0;
for i=1:4
    ans = ans + c(i) * (pt^(4-i));
end

end
