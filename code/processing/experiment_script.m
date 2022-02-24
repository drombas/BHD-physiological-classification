%% Experiment
close all;clc;clearvars;
addpath(genpath('utils'));

in_dir = '../../data/EUSKALIBUR/hbm_physio_challenge/';
S0 = readtable([in_dir,'time_series.csv']);
annot = readtable([in_dir,'annotations.csv']);
clear in_dir;
%% Original signals
[n_samp, n_s] = size(S0);

T = 1/100;  % Sampling period
t0 = 0:T:T*(n_samp-1);

non_cardiac = strcmp(annot.type,'cardiac');
% save_signal('figures/signals_raw/', t0, S0, annot, 'signal', [])
disp('ack-original');
%% Window
t_start = 60;
t_end = 120;
[t, S] = crop_signal(t0, S0, t_start, t_end);

% save_signal('figures/signals_window/', t, S, annot, 'signal', [])
disp('ack-window');
%% Smooth and normalize
span = 0.01;
S1 = S;
for n=1:n_s
    s = S{:,n};
    s = smooth(s, span, 'loess');
    S1{:,n} = (s - min(s))/(max(s)-min(s));
end
% save_signal('figures/signals_smooth/', t, S1, annot, 'signal', []);
disp('ack-smooth');
%% Maxima and minima
max_prom = 0.1;
max_dist = 100;

min_prom = 0.1; 
min_dist = 100;

found_peaks = struct;

for n=1:n_s
    s = S1{:,n};
    
    if strcmp(annot.type{n}, 'cardiac')
        found_peaks(n).max = nan;
        found_peaks(n).min = nan;
    end
    
    [~, found_peaks(n).max] = findpeaks(s,'MinPeakProminence', max_prom, 'MinPeakDistance', max_dist);  % maxima
    [~, found_peaks(n).min] = findpeaks(-s,'MinPeakProminence', min_prom,'MinPeakDistance', min_dist);  % minima
end
% save_signal('figures/signals_peaks/', t, S1, annot, 'signal_peaks', found_peaks);
disp('ack-minmax');
%% Get time-domain features

X = get_time_features(t, S1, found_peaks);
disp('ack-time-features');
%% Visualization
f = figure(1);clf;hold on;
sig_type = {'respiratory_chest','respiratory_CO2','respiratory_O2'};

for n=1:length(sig_type)
    selec = strcmp(annot.type, sig_type{n});
    scatter(vertcat(X(selec).ad_up),vertcat(X(selec).ad_down),'filled','MarkerFaceAlpha',0.6);
end
grid on;
legend(sig_type, 'Interpreter', 'none');set(gca,'FontSize',12);

%% Classification 
is_resp = ~strcmp(annot.type, 'cardiac');
% n_resp = sum(is_resp);

Yresp = annot.type_num;
Xresp = vertcat(X.ad_down);

th1 = -0.02;
th2 = -0.1;

Ypred = nan(n_s,1);

Ypred(~is_resp) = 2;
Ypred(is_resp & Xresp > th1) = 1;
Ypred(is_resp & Xresp > th2 & Xresp <=th1) = 4;
Ypred(is_resp & Xresp <= th2) = 3;

figure;
subplot(121);hold on;
ind = [1 3 4];
for s=1:3
    scatter(ind(s) -1 + ones(1,sum(Yresp==ind(s))), Xresp(Yresp==ind(s)));
end
plot([1 4],[th1 th1],'--k');
plot([1 4],[th2 th2],'--k');

C = nan(3,3);
for i=1:4
    for j=1:4
        C(i,j) = sum(Ypred(Yresp==i) ==j)/sum(Yresp==i)*100;
    end
end

subplot(122);
imagesc(C);
xticks(1:4);
xticklabels({'chest','cardiac','CO2','O2'})
yticks(1:4);
yticklabels({'chest','cardiac','CO2','O2'})
