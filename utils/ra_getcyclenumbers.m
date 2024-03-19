function cycle_nums = ra_getcyclenumbers(float_ids, Data)
% creating a cycle number in addition to float_profs to trace the individual
% profile in the floatdata while retaining the original float_profs index

nfloats = length(float_ids);
cycle_nums = cell(nfloats, 1);
%
for f = 1:nfloats
    str_floatnum = ['F', num2str(float_ids(f))];
    % selecting only profiles that needs
    cycle_nums{f} = Data.(str_floatnum).CYCLE_NUMBER(1,:);
end%endfor
end%end get_cycle_numbers