function r = repeat(a,n)

d = ones(1,ndims(a));
d(end) = n;

r = repmat(a,d);