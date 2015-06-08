function r = riffle(a,v)

if iscell(a)
    r = cell(size(a,1),2*size(a,2)-1);
    for x = 1:size(a,2)
        for y = 1:size(a,1)
            r{y,2*x-1} = a{y,x};
        end
    end
    for x = 2:2:2*size(a,2)-1
        for y = 1:size(a,1)
            r{y,x} = v;
        end
    end
elseif not(isstruct(a))
    siz = size(a);
    siz(end) = 2*siz(end)-1;
    switch ndims(a)
        case 2
            r(:,1:2:siz(end)) = a;
            r(:,2:2:siz(end)) = v;
        case 3
            r(:,:,1:2:siz(end)) = a;
            r(:,:,2:2:siz(end)) = v;
        case 4
            r(:,:,:,1:2:siz(end)) = a;
            r(:,:,:,2:2:siz(end)) = v;
        case 5
            r(:,:,:,:,1:2:siz(end)) = a;
            r(:,:,:,:,2:2:siz(end)) = v;
        otherwise
            error('not implemented');
    end
else
    error('not defined');
end
    