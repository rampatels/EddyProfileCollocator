%% Automate collocation of mesoscale eddies and ship-based hydrographic observations
%{
We will begin by loading respective datasets. For the purpose of this tutorial, I have downloaded and prepared `.mat` files, which can be found in the `data` directory. Specifically, I selected an expedition from [GO-SHIP](https://cchdo.ucsd.edu/search?q=GO-SHIP) conducted between Tasmania and Antarctic in 2011. This expedition encountered both cyclonic and anticyclonic eddies, providing a valuable dataset for our analysis. For mesoscale eddies, I have subsetted eddies from the Faghmous et al. 2015 datasets specifically for the year 2011 which has been updated with closed contours. For details on processing the eddy datasets, please refer to [OceanEddies](https://github.com/rampatels/OceanEddies) and [OceanEddiesToolbox](https://github.com/rampatels/OceanEddiesToolbox).
%}
clear;clc
% load hydrographic data
dir_path = '~/Documents/ToGitHub/EddyProfileCollocator';
load(strcat(dir_path,'/data/', 'sr03voyages_tutorial.mat'))
% load mesoscale eddies
load(strcat(dir_path,'/data/', 'fageddies_tutorial.mat'))

%{
**NOTE:** The original intent of EddyProfSync is to collocate mesoscale eddies and Argo profiles using the Mesoscale Eddies Trajectory Atlas (META) disseminated by AVISO. Therefore, the nomenclature used in the software follows the META variable name convention. **Users should ensure that their eddy data adheres to the META variable name convention**. In other words, the eddy center x position should be renamed as longitude, and the y position should be renamed as latitude. The contours used to match the profiles surfaced in eddies should have either effective_contour_longitude/latitude or speed_contour_longitude/latitude, depending on the eddy tracking algorithm that you have used for your research.

The Faghmous data used here follows Chelton's variable name convention. Additionally, they store the outermost closed contours to define the eddy boundary. This definition of the eddy boundary is similar to META's effective_contour. Nonetheless, I have written a function called `ra_fagwithshape2meta.m`, which can be found in the `utils` directory, that converts this format to the META variable convention. For interested readers, please refer to your GitHub repository of eddy shape.
%}

% Update the field names in Fagdata to conform nomenclature of EddyProfSync

cyc_metafmt = ra_fagwithshape2meta(cycdata);
acyc_metafmt = ra_fagwithshape2meta(acycdata);

%{
EddyProfSync requires two indices for matching eddies and surfaced profiles. To index eddies, we use row numbers, as the data is stored in a tabular format where each row corresponds to a distinct eddy realization. For hydrographic observations, the index variable should consist of two columns – the first column representing the voyage name and the second column representing the corresponding stations. These structures allow easy tracing back to the original .nc file if needed. These indices play a crucial role in the collocation process, constituting a unique and integral feature of EddyProfSync.
%}
% Prepare Index input for hydrographic observations
[voyagenums, prefixes]= Ecode2voyagenums(Ecode);
voyageidnstnnum = [voyagenums, stations];

%{
Convert time variable to datenum of the day only.
Because usually voayges records date and time.
%} 
a = datevec(times);
voyagedates = datenum(a(:,1), a(:,2), a(:,3));%#ok
clear a;
%{
We will initially define an index for cyclonic eddies and collocate them. Subsequently, we will collocate anticyclonic eddies with the remaining profiles. In both cases, we will also filter eddies for the sampling period. This workflow optimizes the performance of EddyProfSync by eliminating unnecessary checks for surface profiles when none are available. While EddyProfSync doesn't mind skipping to the next day, this optimization ensures a smoother execution.
%}

% Prepare EddyIndex input for cyclonic eddies
time_cyc = cyc_metafmt.time;

% Optimise for sampling period
prof_start = min(voyagedates); % to filter eddies data
prof_end = max(voyagedates); % to filter eddies data
%
valdate = time_cyc >= prof_start & time_cyc <= prof_end;

% Get corresponding parameters from dates
edates = time_cyc(valdate); % eddy time

% EDDYINDEX input
eindex = find(valdate); % the index that falls in sampling period
clear valdate prof_start prof_end

%{
With our indices prepared, we now have all the necessary inputs to execute EddyProfSync.
%}

% Get profiles that are surfaced in cyclonic eddies
addpath(strcat(dir_path,'/src/'))

%
[cInprofid, cIneddyidx] = find_profineddy(cyc_metafmt, eindex, edates, ...
    lons, lats, voyageidnstnnum, voyagedates, 'effective');

%{
EddyProfSync generates two cell arrays containing matched pairs of eddies and surfaced profiles, each accompanied by its respective indices. Subsequently, I will convert them into arrays for further analysis.
%}

% Convert to array from cell array
cycsr3stnid = cell2mat(cInprofid);
cycindex = cell2mat(cIneddyidx);
clear cIn*

%{
Next, we extract profiles outside of cyclonic eddies for further categorization, eliminating unnecessary checks for profiles associated with cyclonic eddies in the subsequent step. Although the overlap of cyclonic and anticyclonic eddies is unlikely due to the accuracy of eddy tracking algorithms, we won't assume it. Therefore, I will remove the profiles surfaced in cyclonic eddies from the hydrographic observations data.
%}
% Sampled profiles that are not in cyclonic eddies
insidecyc = ismember(voyageidnstnnum, cycsr3stnid,'rows');
outsidecyc = ~insidecyc;

% Get corresponding  informations
outsidecycfpid = voyageidnstnnum(outsidecyc,:);
outsidecyclon = lons(outsidecyc);
outsidecyclat = lats(outsidecyc);
outsidecycday = voyagedates(outsidecyc);

% To Visualise results in final step
cycargolon = lons(insidecyc); 
cycargolat = lats(insidecyc);
cycargodate = voyagedates(insidecyc);

%{
We proceed to identify profiles surfaced in anticyclonic eddies. To achieve this, we first create an EddyIndex for anticyclonic eddies, as discussed above, and then apply EddyProfSync.
%}
% Prepare EddyIndex for anticyclonic eddies
time_acyc = acyc_metafmt.time;

% Get sampling date range from outside cyclonic eddies profile
prof_start = min(outsidecycday); % to filter eddies data
prof_end = max(outsidecycday); % to filter eddies data

%
valdate = time_acyc >= prof_start & time_acyc <=prof_end;

% Get corresponding parameters from the data set
edates = time_acyc(valdate); % eddy time

% EDDYINDEX input
aeindex = find(valdate); % the index that falls in sampling period
clear valdate

% Collocation for anticyclonic
[cInprofid, cIneddyidx] = find_profineddy(acyc_metafmt, aeindex, edates,...
    outsidecyclon, outsidecyclat, outsidecycfpid, outsidecycday, 'effective');

% Convert to array from cell array
acycsr3stnid = cell2mat(cInprofid);
acycindex = cell2mat(cIneddyidx);
clear cIn*

% To visualise the collocation 
% Profiles that are not in anticyclonic eddies
insideacyc = ismember(outsidecycfpid, acycsr3stnid,'rows');
acycargolon = outsidecyclon(insideacyc); 
acycargolat = outsidecyclat(insideacyc);
acycargodate = outsidecycday(insideacyc);

%{
Animate the collocated outputs for both cyclonic and anticyclonic eddies.
%}
% Prepare GIF for profiles that are surfaced in cyclonic eddies
filename = strcat('BGCSR03InCycloniceddies', '.gif');
%
fig = figure(1);
for iee = 1:length(cycindex)
    ceidx = cycindex(iee);
    % Read effective contours
    eloncont = cyc_metafmt.effective_contour_longitude(:, ceidx);
    elatcont = cyc_metafmt.effective_contour_latitude(:, ceidx);

    % Plotting argo surfaced in
    plot(cycargolon(iee), cycargolat(iee), '.k', 'MarkerSize',15) % plotting in or on argo profiles
    hold on
    plot(cyc_metafmt.longitude(ceidx), cyc_metafmt.latitude(ceidx), '*', 'Color', rgb('blue'))
    plot(eloncont, elatcont, '-', 'Color', rgb('blue'), 'linewidth', 1.5)
    
    hold off

    tname = ['Eddy ID: ', num2str(cyc_metafmt.track(ceidx))];
    ntitle([datestr(cycargodate(iee)), ' ; ', datestr(cyc_metafmt.time(ceidx)) ], 'fontsize', 14, 'fontweigh', 'bold')
    title(tname, 'fontsize', 16, 'fontweigh', 'bold')
    set(gca, 'linewi', 1.5, 'fontsize', 14, 'fontweigh', 'bold')

    % Capturing the plot as an image
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF file
    if iee == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1)
    end
 clear frame im imind cm tind
end
clf;close all

% Prepare GIF for profiles that are surfaced in anticyclonic eddies

filename = strcat('BGCSR03InAnticycloniceddies', '.gif');
%
fig = figure(1);
for iee = 1:length(acycindex)
    ceidx = acycindex(iee);
    % Read effective contours
    eloncont = acyc_metafmt.effective_contour_longitude(:, ceidx);
    elatcont = acyc_metafmt.effective_contour_latitude(:, ceidx);

    % Plotting argo surfaced in
    plot(acycargolon(iee), acycargolat(iee), '.k', 'MarkerSize',15) % plotting in or on argo profiles
    hold on
    plot(acyc_metafmt.longitude(ceidx), acyc_metafmt.latitude(ceidx), '*', 'Color', rgb('red'))
    plot(eloncont, elatcont, '-', 'Color', rgb('red'), 'LineWidth',1.5)
    hold off
    tname = ['Eddy ID: ', num2str(acyc_metafmt.track(ceidx))];
    ntitle([datestr(acycargodate(iee)), ' ; ', datestr(acyc_metafmt.time(ceidx)) ], 'fontsize', 14, 'fontweigh', 'bold')
    title(tname, 'fontsize', 16, 'fontweigh', 'bold')
    set(gca, 'linewi', 1.5, 'fontsize', 14, 'fontweigh', 'bold')
%     pause(2)
    % Capturing the plot as an image
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    
    % Write to the GIF file
    if iee == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1)
    end
 clear frame im imind cm tind
end
clf;close all