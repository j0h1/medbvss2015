function r = at(a,ind)
import fm.*

assert(isscalar(ind));

if isempty(a)
    if iscell(a)
        r = {};
    else
        r = [];
    end
    return
end


if iscell(a)
    r = a{ind};
elseif isstruct(a)
    r = a(ind);
else
    n = ndims(a);
    r = eval(['a(' repeat(':,',n-1) 'ind)']);
end

