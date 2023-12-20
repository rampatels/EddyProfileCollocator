function [cinprofid, cineddyindex] = collocateeddynprof(eddy_var, eddyindex, alon, alat, fprofid, varargin)
    % Collocate argo profiles and mesoscale eddies.
    % OUTPUTs: 
    % cfnprofid:    Collocated float and profile id mx2, 1-float id, 2, profid
    % ceddyindex:   Collocated eddy index to retreive its properties
    % At this stage output will be stored in a cell array
    % INPUT:
    % eddy_var(struct):     Eddy structure file - var=nc2mat('meta_trajectory.nc')
    % eddyindex(mx1):       Eddy index file - to retrieve various properties from var
    % a_xpos(mx1):          Cartesian x position of the sampling profile
    % a_ypos(mx1):          Cartesian y position of the sampling profile
    % fprofid(mx2):         1st column - float ids, 2nd column profile ids
    
    % Validate the inputs
    validateattributes(eddyindex, {'numeric'}, {'vector', 'nonempty', 'nonnan'}, 'collocateeddynprof', 'eddyindex');
    validateattributes(alon, {'numeric'}, {'vector', 'nonempty', 'nonnan'}, 'collocateeddynprof', 'alon');
    validateattributes(alat, {'numeric'}, {'vector', 'nonempty', 'nonnan'}, 'collocateeddynprof', 'alat');
    validateattributes(fprofid, {'numeric'}, {'2d', 'nonempty', 'nonnan'}, 'collocateeddynprof', 'fprofid');
    
    % Define default contour type and constraint
    p = inputParser;
    validContourTypes = {'effective', 'speed'};% valid contour type names
    defaultContourType = 'effective'; % default values for the contour type
    addOptional(p, 'contourType', defaultContourType, @(x) any(validatestring(x, validContourTypes)));
    
    % Parse the inputs
    parse(p, varargin{:});
    contour_type = p.Results.contourType;
    
    % 0: Get eddy boundaries for a given type of contour
    [xv_cartesian, yv_cartesian] = geteddyboundary(eddy_var, eddyindex, contour_type);
    
    % Convert longitudes and latitudes to Cartesian coordinate
    [xq_cartesian, yq_cartesian] = convert2cartesian(alat, alon);
    
    % 1: Find Argo surfaced IN or ON eddy boundary
    [in, on] = inpolygon(xq_cartesian, yq_cartesian, xv_cartesian, yv_cartesian); % Remove `on` for accuracy check
    if isempty(alon(in | on))
        disp('no profile in any eddy!!')
        [cinprofid, cineddyindex] = deal({});
        return
    end
    % surfaced argo profiles in eddies
    surflon = xq_cartesian(in | on); % surfaced argo 
    surflat = yq_cartesian(in | on); % surfaced argo
    surfprofid = fprofid(in | on, :);
    
    % 2: Match the surfaced Argo profiles to its eddy
    [cinprofid, cineddyindex] = matcheddy(eddy_var, eddyindex, surflon, surflat, surfprofid, contour_type);
    
%     % % temporary check
%     ceidx = cell2col(cineddyindex, 'nonans');
%     plot(alon(in | on), alat(in | on), '.k') % plotting in or on argo profiles
%     hold on
%     plot(eddy_var.longitude(ceidx), eddy_var.latitude(ceidx), '.', 'Color', [0.8500 0.3250 0.0980])
%     plot(eddy_var.effective_contour_longitude(:, ceidx), ...
%         eddy_var.effective_contour_latitude(:, ceidx), '-', 'Color',[0.8500 0.3250 0.0980])
end% main() function

%---- Function to read eddy boundary based on contour type
function [xv_cartesian, yv_cartesian] = geteddyboundary(eddy_var, eddyindex, contour_type)
% GETEDDYBOUNDARY reads an eddy boundary and transforms to Cartesian coordinate 
% to conform inpolygon and knnsearch function

% Get eddy boundaries for a given type of contour
    switch contour_type
        case 'effective'
            eloncontour = eddy_var.effective_contour_longitude(:, eddyindex);
            elatcontour = eddy_var.effective_contour_latitude(:, eddyindex);
        case 'speed'
            eloncontour = eddy_var.speed_contour_longitude(:, eddyindex);
            elatcontour = eddy_var.speed_contour_latitude(:, eddyindex);
        otherwise
            error('Invalid contour type. Please use either "effective" or "speed".');
    end%endswitch - contourType
    
    % Convert eddy boundaries to a vector
    xv = mat2col(eloncontour); yv = mat2col(elatcontour);
    
    % Convert longitudes and latitudes to Cartesian coordinate
    [xv_cartesian, yv_cartesian] = convert2cartesian(yv, xv);
end% endfunction - eddyboundary

%----- Function to match eddies to appropriate argo profiles----
function [cInprofid, cIneddyidx] = matcheddy(eddyvar, eddyindex, surfprof_lon_cartesian, surfprof_lat_cartesian, surffidprofid, contour_type)
    % MATCHEDDY find eddies that has encapsulated argo profiles after filtering
    % non surfaced profile.
    
    % Find the nearest eddies for the surfaced argo profiles
    % To Cartesian coordinate, eddies' centre for a given day
    % Because knnsearch computes euclidean distance which requires Cartesian
    % coordinate
    elat = eddyvar.latitude(eddyindex); % eddy centre latitude 
    elon = eddyvar.longitude(eddyindex); % eddy centre longitude
    [elon_cartesian, elat_cartesian] = convert2cartesian(elat, elon); 
    
    % Apply k-nearest neighbour algorithm to identify five nearest eddy to the
    % surfaced profile in eddy
    X = [elon_cartesian, elat_cartesian]; % eddies' centre
    Y = [surfprof_lon_cartesian, surfprof_lat_cartesian]; % profiles surfaced in eddies
    [idx] = knnsearch(X, Y, "K", 5, 'Distance','euclidean');
    
    % Select only unique nearest eddies
    nearesteddies = unique(idx);
    %
    cInprofid = {}; % initialise cell array
    cIneddyidx = {}; % initialise cell array

    % Loop over each nearest eddy for Argo profile
    for inearest = 1:length(nearesteddies)
        disp('Finding the nearest eddy enclosing argo profiles')
        
        eidx = nearesteddies(inearest);
        searcheddyidx = eddyindex(eidx); % the nearest eddy index
        
        % Get boundery of the nearest eddy
        [xv_cartesian, yv_cartesian] = geteddyboundary(eddyvar, searcheddyidx, contour_type);
        
        % Check profile surfacing IN or ON the nearest eddy
        [in, ~] = inpolygon(surfprof_lon_cartesian, surfprof_lat_cartesian, xv_cartesian, yv_cartesian); %%% Remove `on` from here
        
        % If profiles surfaced in (IN | ON) the eddy then note corresponding profile
        % id float id and an eddy index
        if ~isempty(surfprof_lon_cartesian(in))
            disp(['Found the eddy:', num2str(searcheddyidx)])
            cInprofid{end+1,1} = surffidprofid(in, :); %#ok main output, Use comma-separated list assignment
            cIneddyidx{end+1,1} = repmat(searcheddyidx, sum(in), 1);%#ok main output, Use comma-seperated list assignment
        else
            continue
        end% endif store data only if found matched argo profile and eddies
    end% endfor - nearest eddy search loop
end% endfunction - matcheddy


%--- Function transforms latitude and longitude coordinates to Cartesian coordinates
function [x_cartesian, y_cartesian] = convert2cartesian(latitude, longitude)
    % convert2cartesian projects longitude and latitudes to Cartesian
    % cooridnate because `inpolygon` works best with it. This step doesn't
    % matter for smaller study region but make a big difference for larger
    % region.
    
    % Validate inputs
    validateattributes(latitude,{'numeric'}, {'column','nonempty'},'convert2cartesian','latitude')
    validateattributes(longitude,{'numeric'}, {'column','nonempty'},'convert2cartesian','longitude')
    assert(numel(longitude) == numel(latitude),'convert2cartesian: longitude and latitude should be same size')

    % Create default projection
    proj = defaultm('mercator');
    proj.geoid = referenceSphere('earth'); % Earth's radius in meters
    
    % Convert latitude and longitude coordinates to Cartesian coordinates
    [x_cartesian, y_cartesian] = projfwd(proj, latitude, longitude);
end% endfunction - convert2cartesian