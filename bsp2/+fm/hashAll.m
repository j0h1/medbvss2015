function r = hashAll(a)
import fm.*

if isempty(a)
    r = hash(0);
elseif iscell(a)
    r = hash(flatten(map(@hashAll,a)));
elseif isa(a,'function_handle')
    r = hash(func2str(a));
elseif isstruct(a)
    r = flatten(map(@hashAll,flatten(a)));
else
    a = single(a);
    if numel(a) > 1000
        indices = 1:round(29*(numel(a)/1000)):numel(a);
        a = reshape(a(indices),1,[]);
    end
    if isempty(a)
        a = [0 NaN];
    end
    r = hash(a(:)');
end
