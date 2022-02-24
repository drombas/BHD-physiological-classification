function X = get_time_features(t, s, mins, maxs)
% Compute time-domain features from a signal
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

X = struct;

% Initialize features
time_total = nan;
time_up = nan;
time_down = nan;
ad_up = nan;
ad_down = nan;

ii=1;
for j=1:length(mins)-1

    % Get minimum       
    x1 = mins(j);        
    t1 = t(x1);
    y1 = s(x1);

    % Get next minimum
    x3 = mins(j+1);
    t3 = t(x3);
    y3 = s(x3);

    % Find maximum in between
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

    x2 = maxs(ind_max);
    t2 = t(x2);
    y2 = s(x2);

    % Upper part (min to max)
    x_up = x1:x2;
    t_up = t(x_up);
    y_up = s(x_up);        
    y_up_c = (y2-y1)/(t2-t1)*(t_up -t1) + y1;  % straight line

    % Down part        
    x_down = x2:x3;
    t_down = t(x_down);
    y_down = s(x_down);        
    y_down_c = (y3-y2)/(t3-t2)*(t_down -t2) + y2;  %  straight line


    plot(t_up,y_up,'--r');
    plot(t_up,y_up_c,'--m');
    plot(t_down,y_down,'--k');
    plot(t_down,y_down_c,'--g');           

    % Tidal time respec
    time_up(ii) = t2 - t1;
    time_down(ii) = t3 - t2;
    time_total(ii) = t3 - t1;

    % Area diffeernce (line vs signal)
    ad_up(ii) = mean(y_up - y_up_c');
    ad_down(ii) = mean(y_down - y_down_c');
    ii = ii + 1;    
end

% Compute features
X(n).ad_up = mean(ad_up);
X(n).ad_down = mean(ad_down);
aux = 100*(time_up-time_total)./time_total;
X(n).time_up_rel = mean(aux);
X(n).NT = 100*sum(aux < 50)/length(aux);
