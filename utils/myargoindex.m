function newindex = myargoindex(floats_id, cycnums)
% myargoindex creates index to match argo and eddies
% I use an array of float id and cycle numbers as an index.
%
% Ramkrushn Patel

% converting all into a column 
s_floats = arrayfun(@(c, el) repmat(el, size(c{1})), cycnums, floats_id, 'UniformOutput', false);
argofloatid = cell2col(cellfun(@(x) x', s_floats, 'UniformOutput', false), 'nonans');
argoprofid = cell2col(cellfun(@(x) x', cycnums, 'UniformOutput', false), 'nonans'); % to talk with local data

% new index
newindex = [argofloatid, argoprofid];