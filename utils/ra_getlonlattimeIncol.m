function [argo_lon, argo_lat, argo_time, argo_date] = ra_getlonlattimeIncol(lonincell,latincell,timeincell)
% function converts cell array into a column, output of get_lon_lat_time
% into a column for further analyses
% This is a part of collocation software.

argo_lon = cell2col(lonincell, 'nonans');
argo_lat = cell2col(latincell, 'nonans'); 
argo_time = cell2col(timeincell, 'nonans');
argotime_dn = datevec(argo_time);
argo_date = datenum(argotime_dn(:,1), argotime_dn(:,2), argotime_dn(:,3));
 