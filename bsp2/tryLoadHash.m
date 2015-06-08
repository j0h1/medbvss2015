function [recompute, s, hashData] = tryLoadHash(p, s, name, version, varargin)
% function [recompute, s, hashData] = tryLoadHash(p, s, name, version, varargin)
%
% function tryLoadHash caches a function output by creating a hash of the input argumens
% and saves it to a file
%
% Parameters:
%   p               settings, valid is
%     hsDoLoads       if 0 the recompute is always true 
%     hsFilePrefix    defines the directory name and the prefix for the filename
%     onlyUseFilePrefix     if 1, only uses filename as FilePreFix instead
%     of directory+fileprefix when stored in seperate directory
%   s               is that data that is cached to the file
%   name            the name of the function
%   version         a version field
%   varargin        the parameters that should be hashed

dp.hsDoLoads = 1;
dp.hsNoLoadNoRecompute = 0;
dp.hsFilePrefix = 'zzz';
dp.hsZzzBaseDir = '';
dp.onlyUseFilePrefix = 0;
dp.hsQuietLoads = false;
dp.hsQuietSaves = false;
p = defaultParams(p,dp);

recompute = 1;

hashdata = cell(1,length(varargin));

for x = 1:length(varargin)
    if isstruct(varargin{x})
        S = struct2cell(structfun(@structField2num,varargin{x},'UniformOutput',0));
        hashdata{x} = single(cell2mat(S)');
    else
        temp = varargin{x};
        if isa(temp,'function_handle')
            temp = escapePath(func2str(temp));
        end
        if iscell(temp)
            temp2 = cell(1,numel(temp));
            for i = 1:numel(temp)
                if isa(temp{i},'function_handle')
                    temp{i} = escapePath(func2str(temp{i}));
                end
                temp2{i} = single(reshape(temp{i},[],1))';
            end
            temp = cell2mat(temp2);
            clear temp2;
        end
        temp = single(temp);
        if numel(temp) > 1000
            indices = 1:round(29*(numel(temp)/1000)):numel(temp);
            temp = reshape(temp(indices),1,[]);
        end
        hashdata{x} = temp(:)';
    end
    if not(isreal(hashdata{x}))
        hashdata{x} = [real(hashdata{x}); imag(hashdata{x})];
    end
end

h = hash([version cell2mat(hashdata)]);

hashData.filename = strcat(pwd,filesep,p.hsFilePrefix,filesep,p.hsFilePrefix,escapePath(name), h ,'.mat');
if not(isempty(p.hsZzzBaseDir))
    if not(exist(p.hsZzzBaseDir,'dir'))
        error(['Specified directory p.hsZzzBaseDir="' p.hsZzzBaseDir '" does not exist. Please create it.']);
    end
    n = min(length(hashData.filename), length(p.hsZzzBaseDir));
    startInd = find(hashData.filename(1:n)~=p.hsZzzBaseDir(1:n));
	hashData.filename = hashData.filename(startInd:end);
      
    hashData.filename = [p.hsZzzBaseDir filesep escapePath(hashData.filename)];
    if p.onlyUseFilePrefix
        hashData.filename = [p.hsZzzBaseDir filesep escapePath(p.hsFilePrefix) escapePath(name) h '.mat'];
    end
end


if p.hsDoLoads
    try
        tic
        loaded = load(hashData.filename);
        for field = fieldnames(loaded)'
            s = setfield(s, field{1}, getfield(loaded, field{1}));
        end
        t = toc;
        if not(p.hsQuietLoads)
            disp(['... reloaded ' name '! (elapsed time is ' num2str(t) ' seconds.)']);
        end
        recompute = 0;
        return
    catch
    end
elseif p.hsNoLoadNoRecompute 
    disp(['... reloaded only hashfile info of: ' name '!']);
    recompute = 0;
    return
end

if not(p.hsQuietSaves)
    disp(['need to recompute ' name ' ...']);
end


%% depricated -> can be found under various!!!!
% function r = structField2num(x)
% 
% if not(isempty(x))
%     % if struct contains cell
%     if iscell(x)
%         % cell with different sized content
%         len=cellfun(@length,x);
%         if length(unique(len)) > 1
%             r = [];
%             for i = 1:length(x)
%                c = single(x{i});
%                r = [r c(:)'];
%             end
%             r = r';
%         else
%             temp = single(cell2mat(x))';
%             r = temp(:);
%         end
%     elseif isstruct(x)
%         r = struct2cell(x);
%         for i = 1:length(r)
%             if ischar(r{i})
%                 r{i} = str2double(r{i});
%                 if isnan(r{i}) || isempty(r{i})
%                     r{i} = 0;
%                 end
%             end
%         end
%         r = single(cell2mat(r));
%     else
%         r = single(reshape(x,1,[])');
%     end
% else
%     r = single(0);
% end

function r = escapePath(filename)

r = filename;
r(r=='/') = [];
r(r=='\') = [];



