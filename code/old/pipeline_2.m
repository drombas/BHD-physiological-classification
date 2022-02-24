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
f = figure('visible','off');
plot_data = true;
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
    for j=2:length(maxs)-1
        % Get maximum        
        x1 = maxs(j);        
        t1 = t(maxs(j));
        y1 = s(maxs(j));
        
        % Get next maximum
        x3 = maxs(j+1);
        
        % Find minimums between
        ind_min = find(mins > x1 & mins < x3);
        
        % No maxima found            
        if isempty(ind_min)
            warning('no minima found');
            continue;
        end        
        if length(ind_min)> 1
           warning('More than one maxima found');
           continue
        end
%         
        x2 = mins(ind_min);
        t2 = t(x2);
        y2 = s(x2);
        
        % If slope was constant vs. real
        x_r = x1:x2;
        t_r = t(x_r);
        y_r = s(x_r);
        y_c = (y2-y1)/(t2-t1)*(t_r -t1) + y1;
        
        if plot_data
            subplot(211);  
            plot(t_r,y_r,'--k');
            plot(t_r,y_c,'--b');
        end        
        tidal(ii) = mean(y_r - y_c');
        x_test = x_r(round(0.75*length(x_r)));
        
        % Upper part
        
        n2 = floor(length(x_r)/2);
        slope(ii) = mean(ds(x_r(1:n2)) - ds(x_r(end:-1:end-n2+1)));
        ii = ii + 1;
    end
%     
%     % Compute a single boolean
    MT(i) = mean(tidal);
    NT(i) = mean(slope);



    title([annot.ts_name{i} ' MT:' num2str(round(MT(i),3))]);
    
%     saveas(f,['maxima_location/' annot.ts_name{i} '.png']);
    
    
end

f = figure;
for i=[1 3 4]
    mask = annot.type_num == i;
    scatter(NT(mask),MT(mask),'filled');hold on;
end
legend('chest','o2','co2');grid on;