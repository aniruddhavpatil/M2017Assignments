function [ ans ] = fft1d(arr, w)

n = size(arr,2);
half = n/2;

if n == 1
    ans = arr;
    return

else

  x = 1.0;
  ans = zeros(1,n);

  arr_odd = arr(1:2:n);
  arr_even = arr(2:2:n);

  ans_odd = fft1d(arr_odd, w*w);
  ans_even = fft1d(arr_even, w*w);


  for i = 1:half
      ans(i) = ans_even(i) + (x*ans_odd(i));
      ans(half + i) = ans_even(i) - (x * ans_odd(i));
      x = x * w;
  end

end

end
