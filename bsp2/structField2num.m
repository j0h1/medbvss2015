function r = structField2num(x)

if not(isempty(x))
    % if struct contains cell
    if iscell(x)
        % cell with different sized content
        len=cellfun(@length,x);
        if length(unique(len)) > 1
            r = [];
            for i = 1:length(x)
               c = single(x{i});
               r = [r c(:)'];
            end
            r = r';
        else
            temp = single(cell2mat(x))';
            r = temp(:);
        end
    elseif isstruct(x)
        r = struct2cell(x);
        for i = 1:length(r)
            if ischar(r{i})
                r{i} = str2double(r{i});
                if isnan(r{i}) || isempty(r{i})
                    r{i} = 0;
                end
            end
        end
        
        % cell with different sized content
        len=cellfun(@length,r);
        if length(unique(len)) > 1
            temp = [];
            for i = 1:length(r)
               c = single(r{i});
               temp = [temp c(:)'];
            end
            temp = temp';
        else
            temp = single(cell2mat(r))';
        end
        r = temp(:);
    elseif isa(x,'function_handle')
        r = str2double(escapePath(func2str(x)));
        if isnan(r) || isempty(r)
            r = 0;
        end
    else
        r = reshape(x,1,[])';
    end
else
    r = 0;
end

r = single(r);

function r = escapePath(filename)

r = filename;
r(r=='/') = [];
r(r=='\') = [];