% Visualize all signals in dataset. Includes minimal preprocessing of the
% signals.
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

close all;clc;clearvars;

addpath(genpath('../utils'));

% Load data
in_dir = '../../data/raw/hbm-challenge/';
out_dir = '../data/visu/';
S = readtable([in_dir,'time_series.csv']);
annot = readtable([in_dir,'annotations.csv']);

% Basic data info
[n_samp, n_s] = size(S);
T = 1/100; 
t = 0:T:T*(n_samp-1);

% Plotting
f = figure('Position',[0 0 1400 500],'Visible','on');

n=4; m=1;  % subplots
for i_s=1:n_s
    s = S(:,i_s);
    s_type = annot.type{i_s};
    
    % Original signal
    subplot(n,m,1);
    plot(t,s,'LineWidth',1.5);
    xlabel('s');
    grid on;
    title(s_type);
    
    % Windowed version
    ind = 10;
    t_start = 60;
    t_end = 80;
    [tw, sw] = crop_signal(t, S{:,ind}, t_start, t_end);
    subplot(n,m,2);
    plot(tw,sw,'LineWidth',1.5);
    
    % Smoothed + normalized version
    ss = smooth(sw, 0.01, 'loess');
    ss = (ss - min(ss))/(max(ss)-min(ss));
    subplot(n,m,3);
    plot(tw,ss,'LineWidth',1.5);
    grid on;xlabel('s');

    % Frequencypectrum
    s = s - mean(s);
    fs = 1/T;
    y = fft(s);
    n = length(s);          % number of samples
    f = (0:n-1)*(fs/n);     % frequency range
    power = abs(y).^2/n;    % power of the DFT
    power = power/sum(power);
    subplot(n,m,4);
    plot(f,power,'LineWidth',1.5)
    xlabel('Hz');xlim([0 2]);
    ylabel('Power');grid on;set(gca,'FontSize',12);
    
    % Save plot
    fname = [out_dir s_type '.png'];
    saveas(f, fname);
end
