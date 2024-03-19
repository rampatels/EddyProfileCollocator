function [argo_floats, argo_profiles, match_eddies] = ra_saveinargostruct(collocatedfloatprofileid, collocatededdyindex)
% Function converts argo profile id, float id and collocated eddy index to confirm OneArgo toolbox
% NOTE: matrix must have dimension of Mx2 where M number of profiles. 1st
% column must be float ids, and second column must be corresponding profile
% id. 
% INPUT:
% collocatedfloatprofileid must be Mx2 as explained above
% collocatededdyindex column matrix
% OUTPUT:
% argo_floats as column
% argo_profiles as a struct array to be used with oneargo
% match_eddies to keep eddies in the same as profiles


[argo_floats, ~, ic ]= unique(collocatedfloatprofileid(:, 1), 'stable');
argo_profiles = accumarray(ic, collocatedfloatprofileid(:, 2), [], @(x) {x});
match_eddies = accumarray(ic, collocatededdyindex, [], @(x) {x});