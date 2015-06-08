function saveHash(p, s, hashData, fieldnames)
%saveHash(p, s, hashData, fieldnames)
%
% The function saveHash saves the given fieldnames of a struct s to a cache file.
% This function depends on the results of tryLoadHash!
%
% Parameters:
%   p                 settings, valid is
%       hsDoLoads       if 0 the recompute is always true
%       hsFilePrefix    defines the directory name and the prefix for the filename
%   s                 a struct containing the data that will be saved to the file
%   hashData          a struct that is returned by tryLoadHash containing the filename
%   fieldnames        a cell that holds the fieldnames (from struct s) that will be saved

dp.hsDoSaves = 1;
dp.hsFilePrefix = 'zzz';
dp.hsZzzBaseDir = '';
dp.hsQuietSaves = false;
p = defaultParams(p,dp);

if not(iscell(fieldnames))
    fieldnames = {fieldnames};
end

if p.hsDoSaves
    
    if ~exist([pwd filesep p.hsFilePrefix],'dir') && isempty(p.hsZzzBaseDir)
        mkdir([pwd filesep p.hsFilePrefix]);
    end
    
    if ~exist('fieldnames','var') || isempty(fieldnames)
        s2 = s;
        save(hashData.filename,'-struct','s2');
    else
        s2 = struct;
        for field = fieldnames
            if isfield(s,field{1})
                s2 = setfield(s2,field{1},getfield(s,field{1}));
            end
        end
        try
            save(hashData.filename,'-struct','s2');
        catch
            try
                pause(rand)
                save(hashData.filename,'-struct','s2');
            catch
                pause(rand)
                save(hashData.filename,'-struct','s2');
            end
        end
    end
    if not(p.hsQuietSaves)
        disp('  ... saved');
    end
end
