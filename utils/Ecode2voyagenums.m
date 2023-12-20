function [voyagenums, prefix] = Ecode2voyagenums(Ecode) 
% ECODE2NUMBERS converts strings of GO-SHIP Ecode to numbers for
% collocation software input
%
% INPUT: 
%   Ecode - cell array
% OUTPUTS: 
%   voyagenums - an array containing numbers after removing initial 4 digits from the Ecode 
%   prefix  - initial for digits of each voyages again for restoring to
%   original code for final outputs

% Record prefix - assuming it follows ECODE convention
prefix = cellfun(@(x) x(1:4), Ecode, 'UniformOutput',false);

% Convert remaining digits to numeric array while replacing any _ to 0
voyagenums = cellfun(@(x) str2double(strrep(x(5:end), '_', '0')), Ecode);


end% end - main() 