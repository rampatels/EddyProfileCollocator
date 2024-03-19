function [argo_floats, argo_profiles] = ra_mat2argostruct(argofloatprofileid)
% Function converts argo profile id and float id to confirm OneArgo toolbox
% NOTE: matrix must have dimension of Mx2 where M number of profiles. 1st
% column must be float ids, and second column must be corresponding profile
% id. 
% This function is designed for collocation of eddies and argo profile

[argo_floats, ~, ic ]= unique(argofloatprofileid(:, 1), 'stable');
argo_profiles = accumarray(ic, argofloatprofileid(:, 2), [], @(x) {x});
