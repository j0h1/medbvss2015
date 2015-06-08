function varargout = cache(varargin)

p = struct;
if isstruct(varargin{1})
    p = varargin{1};
    varargin = varargin(2:end);
end

f = varargin{1};
varargin = varargin(2:end);

fname = func2str(f);

%fun = functions(f);
%if isfield(fun,'workspace')
%    hashValue = fm.hashAll({fun.workspace, varargin});
%else
    hashValue = fm.hashAll(varargin);
%end

[recompute, s, h] = tryLoadHash(p, {}, fname, 0, hashValue, nargout);

if recompute
    switch nargout
        case 1
            s.v{1} = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 2
            [s.v{1}, s.v{2}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 3
            [s.v{1}, s.v{2}, s.v{3}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 4
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 5
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 6
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}, s.v{6}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 7
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}, s.v{6}, s.v{7}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 8
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}, s.v{6}, s.v{7}, s.v{8}] = feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 9
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}, s.v{6}, s.v{7}, s.v{8}, s.v{9}] = ...
                feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        case 10
            [s.v{1}, s.v{2}, s.v{3}, s.v{4}, s.v{5}, s.v{6}, s.v{7}, s.v{8}, s.v{9}, s.v{10}] = ...
                feval(f, varargin{:});
            saveHash(p,s,h,{'v'});
        otherwise
            error('not supported');
    end
end

varargout = s.v;
