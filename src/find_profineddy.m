function [cfprofid, ceddyidx] = find_profineddy(eddy_var, eddy_index, eddy_date, prof_lon, prof_lat, prof_uniqueID, prof_date, varargin)
    % FIND_PROFINEDDY identifies surfaced profile in eddy by collocating sampled profile and eddies.
    % The main purpose of this project is to collocate argo profile surfaced in eddy
    % , therefore, some of the variables in the function are named after argo. 
    % But this function would work fine with other types of profiles as well.
    % USAGE:
    %   default behaviour is to use `effective`_contour to identify profile in eddy
    %   [cinprofid, cineddyindex] = find_profineddy(eddy_var, eddy_index, eddy_date, prof_lon, prof_lat, prof_uniqueID, prof_date)
    %   [cinprofid, cineddyindex] = find_profineddy(eddy_var, eddy_index, eddy_date, prof_lon, prof_lat, prof_uniqueID, prof_date, 'effective')
    %   you can also use `speed`_contour
    %   [cinprofid, cineddyindex] = find_profineddy(eddy_var, eddy_index, eddy_date, prof_lon, prof_lat, prof_uniqueID, prof_date, 'speed')
    % INPUTS:
    %   eddy_var: Structure array containing eddy characteristics, output of nc2mat/ncstruct, containing eddies 
    %   ---These two inputs are to ensure subsetting of the original data while
    %   retaining orginal information in the eddy_var---
    %   eddy_index: Column, containing eddy's observation index. To preserve the tracing to
    %               the original .nc file, trim the original index list for sampling era
    %   eddy_date: Column, containing eddy's date trimmed over the sampling era
    %   ---These inputs from the sampling profiles data---
    %   prof_lon (_lat): Column, contains longitude and latitude of the sampled profiles, respectively 
    %   prof_date: Column, contains date of sampled profiles
    %   prof_uniqueID: (length(Column), 2) - this can be prepared as, for example, argo float id and corresponding profile id in a single matrix (float id, profile id)
    % NOTE: 
    %   To optimise collocation, eddy_date and prof_date should have the same date range that is
    %   orginal data should be an intersect of eddy date record and sampling
    %   profile date record. For example, if the argo profile data ranged from 1
    %   jan 2004 to 31 mar 2010 then eddy date should also contain the same data
    %   range.
    % OUPUTS:
    %   cfprofid: Collocated float and profile ids 
    %   ceddyidx: Corresponding eddy index, which can be used to get other
    %   information from eddy_var and argo_struct files.

    % Preambles for robust inputs
    % Create custom validation function to check for the same size
    validateSameSize = @(x, y) assert(numel(x) == numel(y), 'Size mismatch between eddy_* or prof_*!');
    
    % Create custom validation function to check for the size and dimension
    validateSizeAndDimension = @(x, expectedSize, expectedDimension)...
        validateattributes(x, {'numeric'}, {'size', expectedSize, 'ndims', expectedDimension});
    
    % Create custom validation function to check for date format
    validateDateType = @(x) validateattributes(x, {'double'}, {'vector', 'nonempty', 'nonnan', 'finite', 'real', '>=', 0});
    
    % Create an input parser
    p = inputParser;
    
    % Define the expected inputs and their constraints
    addRequired(p, 'eddy_var', @(x) isstruct(x)); % should be a structure array
    addRequired(p, 'eddy_index', @(x) validateSizeAndDimension(x, [NaN 1], 2)); % should be a column vector
    addRequired(p, 'eddy_date', @(x) validateSizeAndDimension(x, [NaN 1], 2));% should be a column vector
    addRequired(p, 'prof_lon', @(x) validateSizeAndDimension(x, [NaN 1], 2)); % same as above but for prof_*
    addRequired(p, 'prof_lat', @(x) validateSizeAndDimension(x, [NaN 1], 2));% same as above but for prof_*
    addRequired(p, 'prof_uniqueID', @(x) isnumeric(x) && size(x, 1) == numel(prof_lon) && size(x, 2) == 2); % should be m x 2 matrix
    addRequired(p, 'prof_date', @(x) validateSizeAndDimension(x, [NaN 1], 2)); % same as prof_*
    
    % Define optional contour_type to allow with default as `effective` and
    % constraints
    validContourTypes = {'effective', 'speed'};% valid contour type names
    defaultContourType = 'effective'; % default values for the contour type
    addOptional(p, 'contourType', defaultContourType, @(x) any(validatestring(x, validContourTypes)));
        
    % Parse the inputs
    parse(p, eddy_var, eddy_index, eddy_date, prof_lon, prof_lat, prof_uniqueID, prof_date, varargin{:});
    contour_type = p.Results.contourType;
    
    % Check the size of input
    validateSameSize(p.Results.eddy_index, p.Results.eddy_date);
    validateSameSize(p.Results.prof_lon, p.Results.prof_date);
    validateSameSize(p.Results.prof_lon, p.Results.prof_lat);

    % Check the datetype
    validateDateType(p.Results.eddy_date);
    validateDateType(p.Results.prof_date);
    %-------------------------

    % Collocate profiles and eddies
    cfprofid = {}; % initialise cellarray
    ceddyidx = {}; % initialise cellarray
    
    %
    loopdays = unique(prof_date); % because there could be many profiles in a day
    
    % Loop over each day 
    for iday = 1:length(loopdays)
        searchday = loopdays(iday); % for a given day
        disp(['Collocating surfaced profile and eddies for: ', datestr(searchday)])%#ok
        %
        onadayargo = prof_date == searchday; % indices to get all argo on a day, for example.
        onadayeddies = eddy_date == searchday; % indices to get all eddies on a day
        
        % Check if there are any eddies or argo found on a day, and continue to the next day if not found
        onadayeidx = eddy_index(onadayeddies);
        %
        if isempty(eddy_var.longitude(onadayeidx))||isempty(prof_lon(onadayargo))
            disp('no eddies or argo found, continue to the next day')
            continue
        end  
        
        % Get all argo parameters for the day
        onadayalon = prof_lon(onadayargo); 
        onadayalat = prof_lat(onadayargo); 
        onadayprofid = prof_uniqueID(onadayargo, :);
    
        % Collocating argo and eddy
        [cinprofid, cineindex] = collocateeddynprof(eddy_var, onadayeidx, onadayalon, onadayalat, onadayprofid, contour_type);
        % Record collocated profile that are `in` or `on` the eddy boundary
        if ~isempty(cineindex) && all(cellfun(@(x) isequal(size(x), size(cinprofid{1})),cinprofid))
            cfprofid{end+1,1} = cell2mat(cinprofid); %#ok
            ceddyidx{end+1,1} = cell2mat(cineindex); %#ok
        end%end if - store output
    end %endfor - for a given day
end %end main function