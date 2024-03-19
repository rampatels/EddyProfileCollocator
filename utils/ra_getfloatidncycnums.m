function [floats, cycnums] = ra_getfloatidncycnums(Data_struct)
% ra_getflaotidncycnums.m extracts floats WMO and cycle numbers for the
% given floats. This function is uses output of qc_filter.m for further
% study
% AUTHOR: Ramkrushn Patel

% get cyclenumbers and write them in cell corresponding to float
cycnums = struct2cell(structfun(@(x) x.CYCLE_NUMBER, Data_struct, 'UniformOutput', false));

% get floats list
names = fieldnames(Data_struct);
floats = str2double(cellfun(@(x) x(2:end), names, 'UniformOutput', false));