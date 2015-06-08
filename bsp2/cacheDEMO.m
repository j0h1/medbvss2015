function cacheDEMO

% demonstrate the use of cache
tic
r1 = costlyComputation(10);
toc
tic
r2 = cache(@costlyComputation,10);
toc
tic
r3 = cache(@costlyComputation,10);
toc

end

function r = costlyComputation(n)
r = zeros(1,n);
for i = 1:n
    x = svd(rand(1000));
    r(i) = x(1);
end
end