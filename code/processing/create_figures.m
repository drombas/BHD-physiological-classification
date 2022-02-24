% Figure
close all;clc;clearvars;
addpath(genpath('utils'));

in_dir = '../../data/EUSKALIBUR/hbm_physio_challenge/';
S0 = readtable([in_dir,'time_series.csv']);
annot = readtable([in_dir,'annotations.csv']);
[n_samp, n_s] = size(S0);
T = 1/100;  % Sampling period
t0 = 0:T:T*(n_samp-1);

non_cardiac = strcmp(annot.type,'cardiac');

%% Window
close all;
lw = 1.5;
colors = {'#E6194B','k','#4363D8','#3cb44b'};

% Cardiac
ind = 10;
t_start = 60;
t_end = 80;
[t, s] = crop_signal(t0, S0{:,ind}, t_start, t_end);
s = smooth(s, 0.01, 'loess');
s = (s - min(s))/(max(s)-min(s));
subplot(411);
plot(linspace(0,t_end-t_start,length(t)),s,'Color',colors{1},'LineWidth',lw);
grid on;xlabel('s');

% chest
ind = 13;
t_start = 60;
t_end = 80;

[t, s] = crop_signal(t0, S0{:,ind}, t_start, t_end);
s = smooth(s, 0.08, 'loess');
s = (s - min(s))/(max(s)-min(s));

mins = [1.97 0.25; 7.96 0;14.27 0.0515];
maxs = [4.47 1; 10.25 0.9254; 16.4 0.923];

subplot(412);hold on;
plot(linspace(0,t_end-t_start,length(t)),s,'Color',colors{2},'LineWidth',lw);
scatter(mins(:,1),mins(:,2),'r','filled');
scatter(maxs(:,1),maxs(:,2),'r','filled');
for i=1:3
    plot([mins(i,1) maxs(i,1)],[mins(i,2) maxs(i,2)],'--r');
end

grid on;xlabel('s');

% O2
ind = 224;
t_start = 30;
t_end = 50;

[t, s] = crop_signal(t0, S0{:,ind}, t_start, t_end);
s = smooth(s, 0.02, 'loess');
s = (s - min(s))/(max(s)-min(s));
subplot(413);
plot(linspace(0,t_end-t_start,length(t)),s,'Color',colors{3},'LineWidth',lw);
grid on;xlabel('s');

% Co2
ind = 131;
t_start = 30;
t_end = 50;

[t, s] = crop_signal(t0, S0{:,ind}, t_start, t_end);
s = smooth(s, 0.04, 'loess');
s = (s - min(s))/(max(s)-min(s));
subplot(414);
plot(linspace(0,t_end-t_start,length(t)),s,'Color',colors{4},'LineWidth',lw);
grid on;xlabel('s');

%%
close all;
figure;hold on;

s = S{:,6};
s = s - mean(s);
fs = 1/T;
y = fft(s);
n = length(s);          % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(y).^2/n;    % power of the DFT
power = power/sum(power);

plot(f,power,'Color',colors{1},'LineWidth',1.5)

s = S{:,1};
s = s - mean(s);
fs = 1/T;
y = fft(s);
n = length(s);          % number of samples
f = (0:n-1)*(fs/n);     % frequency range
power = abs(y).^2/n;    % power of the DFT
power = power/sum(power);
plot(f,power,'Color','k','LineWidth',1.5)

xlabel('Hz');xlim([0 2]);
ylabel('Power');grid on;set(gca,'FontSize',12);
