function r = map(f,a)

if iscell(a)
    r = cell(size(a));
    for i = 1:numel(a)
        r{i} = feval(f,a{i});
    end
elseif isstruct(a)
    for i = numel(a):-1:1
        r{i} = feval(f,a(i));
    end
else
    if isempty(a) || size(a,ndims(a))<1
        r = [];
        return
    else
        switch ndims(a)
            case 2
                r(:,1) = feval(f,a(:,1));
                if size(a,2)>1
                    r(:,size(a,2)) = 0;
                end
            case 3
                r(:,:,1) = feval(f,a(:,:,1));
                if size(a,3)>1
                    r(:,:,size(a,3)) = 0;
                end
            case 4
                r(:,:,:,1) = feval(f,a(:,:,:,1));
                if size(a,4)>1
                    r(:,:,:,size(a,4)) = 0;
                end
            case 5
                r(:,:,:,:,1) = feval(f,a(:,:,:,:,1));
                if size(a,5)>1
                    
                    r(:,:,:,:,size(a,5)) = 0;
                end
            case 6
                r(:,:,:,:,:,1) = feval(f,a(:,:,:,:,:,1));
                if size(a,6)>1
                    r(:,:,:,:,:,size(a,6)) = 0;
                end
            case 7
                r(:,:,:,:,:,:,1) = feval(f,a(:,:,:,:,:,:,1));
                if size(a,7)>1
                    r(:,:,:,:,:,:,size(a,7)) = 0;
                end
            case 8
                r(:,:,:,:,:,:,:,1) = ...
                    feval(f,a(:,:,:,:,:,:,:,1));
                if size(a,8)>1
                    
                    r(:,:,:,:,:,:,:,size(a,8)) = 0;
                end
            case 9
                r(:,:,:,:,:,:,:,:,1) = ...
                    feval(f,a(:,:,:,:,:,:,:,:,1));
                if size(a,9)>1
                    
                    r(:,:,:,:,:,:,:,:,size(a,9)) = 0;
                end
            case 10
                r(:,:,:,:,:,:,:,:,:,1) = ...
                    feval(f,a(:,:,:,:,:,:,:,:,:,1));
                if size(a,10)>1
                    r(:,:,:,:,:,:,:,:,:,size(a,10)) = 0;
                end
            otherwise
                error('too many dimensions');
        end
        switch ndims(a)
            case 2
                for i = 2:size(a,2)
                    r(:,i) = feval(f,a(:,i));
                end
            case 3
                for i = 2:size(a,3)
                    r(:,:,i) = feval(f,a(:,:,i));
                end
            case 4
                for i = 2:size(a,4)
                    r(:,:,:,i) = feval(f,a(:,:,:,i));
                end
            case 5
                for i = 2:size(a,3)
                    r(:,:,:,:,i) = feval(f,a(:,:,:,:,i));
                end
            case 6
                for i = 2:size(a,3)
                    r(:,:,:,:,:,i) = feval(f,a(:,:,:,:,:,i));
                end
            case 7
                for i = 2:size(a,3)
                    r(:,:,:,:,:,:,i) = feval(f,a(:,:,:,:,:,:,i));
                end
            case 8
                for i = 2:size(a,3)
                    r(:,:,:,:,:,:,:,i) = ...
                        feval(f,a(:,:,:,:,:,:,:,i));
                end
            case 9
                for i = 2:size(a,3)
                    r(:,:,:,:,:,:,:,:,i) = ...
                        feval(f,a(:,:,:,:,:,:,:,:,i));
                end
            case 10
                for i = 2:size(a,3)
                    r(:,:,:,:,:,:,:,:,:,i) = ...
                        feval(f,a(:,:,:,:,:,:,:,:,:,i));
                end
            otherwise
                error('too many dimensions');
        end
    end
end
