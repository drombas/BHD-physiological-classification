close all;clc;clearvars;

% Loading signals
TS0 = readtable('../../data/EUSKALIBUR/hbm_physio_challenge/time_series.csv');
annot = readtable('../../data/EUSKALIBUR/hbm_physio_challenge/annotations.csv');

% Configuration parameters
ts = 1/100;
[n_samp,n_ts] = size(TS0);
t0 = 0:ts:ts*(n_samp-1);

% Get a time window
t_int = [60 120];
data_in = t0>=t_int(1) & t0<=t_int(2);
n_samp = sum(data_in);
t = t0(data_in);
TS = TS0(data_in,:);

%% Signal processing
f = figure('visible','on');
plot_data = false;
for i=1:n_ts
    if strcmp(annot.type{i},'cardiac')
        continue;
    end
    
    s = TS{:,i};
    
    % Smoothing
    s = smooth(s,0.01,'loess');
    
    % Normalization
    s = (s - min(s))/(max(s)-min(s));
    
    % Find local maxima
    [pks_max,maxs] = findpeaks(s,'MinPeakProminence',0.1,'MinPeakDistance',100);
    
    % Find local minima
    [pks_min,mins] = findpeaks(-s,'MinPeakProminence',0.1,'MinPeakDistance',100);
    
    % Compute first derivative (in absolute values)
    ds = abs(diff(s));
    
    if plot_data
        clf;
        subplot(211);hold on;
        plot(t,s,'LineWidth',1.5);grid on;title(annot.ts_name{i},'Interpreter','none');
        scatter(t(maxs),s(maxs),'r','filled');
        scatter(t(mins),s(mins),'g','filled');    

        subplot(212);hold on;
        plot(t(2:end),ds,'LineWidth',1.5);grid on;
    end
    
    % Compute tidal times    
    ii = 1;
    tidal = nan;
    for j=1:length(mins)-1
        
        % Get minimum       
        x1 = mins(j);        
        t1 = t(x1);
        y1 = s(x1);
        
        % Get next minimum
        x3 = mins(j+1);
        
        % Find maximum between
        ind_max = find(maxs > x1 & maxs < x3);
        
        % No maxima found            
        if isempty(ind_max)
            warning('no minima found');
            continue;
        end        
        if length(ind_max)> 1
           warning('More than one maxima found');
           continue
        end
%         
        x2 = maxs(ind_max);
        t2 = t(x2);
        y2 = s(x2);
        
        % Upper part
        x_up = x1:x2;        
        x_down = x2:x3;        
        n_up = length(x_up);
        n_down = length(x_down);        
        
        n = 100;
        ind_up = linspace(1,n_up,n);
        ind_down = linspace(1,n_down,n);
        
        y_up = s(x_up);
        y_down = s(x_down);
        
        Y_up(ii,:) = interp1(1:n_up,y_up',ind_up);
        Y_down(ii,:) = interp1(1:n_down,y_down,ind_down);
        
        ii = ii + 1;
    end
    
    Y_up = (Y_up - min(Y_up,[],2))./(max(Y_up,[],2) - min(Y_up,[],2));
    Y_down = (Y_down - min(Y_down,[],2))./(max(Y_down,[],2) - min(Y_down,[],2));
%     % Compute a single boolean
%     MT(i) = mean(slope_up);
%     NT(i) = mean(slope_down);
    clf;
    subplot(121);plot(mean(Y_up),'Linewidth',1.5);grid on;
    subplot(122);plot(mean(Y_down),'Linewidth',1.5);grid on;
    suptitle([annot.ts_name{i}]);
    
%     MT(i) = mean(met);
%         NT(i) = std(met);


%     title(['MT:' num2str(round(MT(i),3))]);
    
%     saveas(f,['maxima_location/' annot.ts_name{i} '.png']);
    
    
end

f = figure;
for i=[1 3 4]
    mask = annot.type_num == i;
    scatter(NT(mask),MT(mask),'filled');hold on;
end
legend('chest','o2','co2');grid on;