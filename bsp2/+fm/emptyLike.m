function r = emptyLike(a)

if iscell(a)
    r = {};
elseif isstruct(a)
    r = struct;
else
    r = zeros(0,class(a));
end