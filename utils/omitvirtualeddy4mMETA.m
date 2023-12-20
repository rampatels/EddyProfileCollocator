function [newstruct] = omitvirtualeddy4mMETA(eddy_var)
% This function removes eddy realisation that are flagged as virtual eddy.
% Because their boundaries (both effective and speed) are not polygon

% Read observation flag
obs_flag = eddy_var.observation_flag;

% Create index for non-virtual eddy 
keepeddy = obs_flag == 0;

%
names = fieldnames(eddy_var);

for ii = 1:length(names)
    var = eddy_var.(names{ii});
    if size(var, 1) == 20
        newstruct.(names{ii}) = var(:, keepeddy);
    else
        newstruct.(names{ii}) = var(keepeddy);
    end
end