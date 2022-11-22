% Compute feature extraction on physiological signals:
% - signal preprocessing
% - maxima-minima location
% - feature extraction
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

close all;clc;clearvars;

addpath(genpath('../utils'));

% Load all signals
in_dir = '../../data/raw/hbm_physio_challenge/';
S = readtable([in_dir,'time_series.csv']);
annot = readtable([in_dir,'annotations.csv']);

% Basic info from signals
[n_samp, n_s] = size(S);
T = 1/100;  % Sampling period
t = 0:T:T*(n_samp-1);

% Processing configuration
t_start = 60;
t_end = 120;
span = 0.01; 
max_prom = 0.1;
max_dist = 100;
min_prom = 0.1; 
min_dist = 100;

X = struct;
for i_s=1:n_s
    % Preprocessing: crop
    [t, s] = crop_signal(t, s, t_start, t_end);

    % Preprocessing: smooth 
    s = smooth(s, span, 'loess');
    
    % Preprocessing: normalize
    s = (s - min(s))/(max(s)-min(s));
    
    % Maxima-minima location
    [mins, maxs] = get_local_peaks(s, min_prom, min_dist, max_prom, ...
                                   max_dist);
   
    % Get time domain features
    X = get_time_features(t, S1, found_peaks);

end
