function r = flatten(a)

if iscell(a)
    if ndims(a)<3
        try
            r = cell2mat(a);
            useOurs = false;
        catch
            useOurs = true;
        end
    else
        useOurs = true;
    end
    if useOurs
        if size(a,1) && iscell(a{1})  % is a list of nested cells
            % reduce level of nesting
            n = sum(fm.flatten(fm.map(@fm.len,a)));
            r = cell(1,n);
            ind = 1;
            for i = 1:fm.len(a)
                for j = 1:fm.len(a{i})
                    r{ind} = a{i}{j};
                    ind = ind + 1;
                end
            end
        else
            if ndims(a)==2
            % make a matrix out of it
            r = block2mat(a);
            else
                siz = size(a{1});
                cellsiz = size(a);
                r = zeros([siz cellsiz]);
                colonstr = fm.flatten(fm.riffle(fm.repeat(':',numel(siz)),','));
                indstr = fm.flatten(fm.riffle(fm.map(@(x) ['v', num2str(x)],mat2cell(1:numel(cellsiz),1,ones(1,numel(cellsiz)))),','));
                for i = 1:numel(a)
                    eval(['[' indstr ']=ind2sub(cellsiz,i);']);
                    eval(['r(' colonstr ',' indstr ')=a{' indstr '};']);
                end
            end
        end
    end
    if isempty(r)
        r = {};
    end
elseif isstruct(a) 
    r = fm.row(struct2cell(a));
else
    dims = size(a);
    if numel(dims)==2
        r = a;
    else
        newdims = dims(1:end-1);
        newdims(end) = prod(dims(end-1:end));
        r = reshape(a,newdims);
    end
end
