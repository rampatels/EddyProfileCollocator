function cyc_meta = ra_fagwithshape2meta(eddies_t)
% RA_FAGWITHSHAPE2META restructure the Chelton's eddy table to META table.
% This function is useful to collocate mesoscale eddies and insitu profiles
% if eddies are tracked using Faghmous et al. 2015 eddy tracking software.

% Validate input
funname = upper('ra_fagwithshape2meta');
if nargin ~= 1
    error(['Invalid number of input arguments.', funname, 'only accepts one input argument.']);
end

if ~isstruct(eddies_t)
    error('Invalid input type. eddies_t should be structure array' )
end

% Change eddy centre field names
cyc_meta.longitude = [eddies_t.x]; 
cyc_meta.latitude = [eddies_t.y];
% NOTE: track_day has been stored as numerical array in format 'yyyymmdd'
% Here I convert it to datenum
cyc_meta.time = datenum(num2str(eddies_t.track_day), 'yyyymmdd'); %#ok 
% eddy type and id
cyc_meta.cyc = [eddies_t.cyc];
cyc_meta.track = [eddies_t.id];
% surface characteristics
cyc_meta.amplitude = [eddies_t.amp];
cyc_meta.effective_area = [eddies_t.area];
cyc_meta.effective_radius = [eddies_t.Ls];

% outermost close contour
fitshapes = eddies_t.fitshape;
% using cellfun
cyc_meta.effective_contour_longitude = cell2mat(cellfun(@(x) x(:, 1), fitshapes, 'UniformOutput', false));
cyc_meta.effective_contour_latitude = cell2mat(cellfun(@(x) x(:, 2), fitshapes, 'UniformOutput', false));