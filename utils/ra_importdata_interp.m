function [newData] = ra_importdata_interp(float_data, float_ids, cyclenums)
% ra_importdata_interp
%
% USAGE:
%   [newData] = ra_importdata_interp(float_data, float_ids, cyclenums)
%
% DESCRIPTION:
%   This function imports data from qced argo profiles for selected cycles
%   only and given float id.
%
% INPUT:
%   float_data  : interpolated and qced data structure
%   float_ids   : WMO ID(s) of one or more floats
%   cyclenums   : required cycle numbers for given float ids in cell array
%
% OUTPUTS:
%   newData: new structure files
%
% AUTHORS:
%   Ramkrushn Patel
%
% CITATION:
%
% DATE: Sep 2023


% initialsing 
Data = float_data;
nfloats = length(float_ids);
names = fieldnames(Data.(['F', num2str(float_ids(1))]));
newData = struct();

% retrieval
for f = 1:nfloats
    str_floatnum = ['F', num2str(float_ids(f))];
    disp(str_floatnum)
    % individual float data
    data = Data.(str_floatnum);
    % selecting only required profiles
    reqprof = ismember(data.CYCLE_NUMBER(1,:), cyclenums{f});
    % getting all the variables and writing 
    for l = 1:numel(names)
        newData.(str_floatnum).(names{l}) = ...
            data.(names{l})(:,reqprof);
    end
end
