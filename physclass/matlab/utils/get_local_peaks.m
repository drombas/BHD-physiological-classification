function [mins, maxs] = get_local_peaks(s, min_prom, min_dist, max_prom, ...
                                        max_dist)
% Find local minima and maxima from a signal
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

% Find maxima
[~, mins] = findpeaks(s,'MinPeakProminence', max_prom, ...
                        'MinPeakDistance', max_dist); 

% Find minima                   
[~, maxs] = findpeaks(-s,'MinPeakProminence', min_prom, ...
                         'MinPeakDistance', min_dist);  % minima