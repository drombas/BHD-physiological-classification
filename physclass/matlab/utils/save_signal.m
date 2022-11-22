function save_signal(path, t, S, annot, type, found_peaks)

n_ts = size(S,1);
f = figure('visible','off');
    
for i=1:n_ts
    clf;
    s = S{:,i}';
    
    switch type
        case 'signal'
            subplot(211);
            plot(t,s);
            title(annot.ts_name{i},'Interpreter','none');xlabel('s');grid on;

            subplot(212);
            plot(t(2:end),abs(diff(s)));
            title(annot.ts_name{i},'Interpreter','none');xlabel('s');grid on;
            saveas(f,[path annot.ts_name{i} '.png']);
            
        case 'signal_peaks'
            
            maxs = found_peaks(i).max;
            mins = found_peaks(i).min;
            
            subplot(211);hold on;
            plot(t,s);
            title(annot.ts_name{i},'Interpreter','none');xlabel('s');grid on;
            
            scatter(t(maxs), s(maxs),'r','filled');
            scatter(t(mins), s(mins),'g','filled');
            
            subplot(212);hold on;
            plot(t(2:end),abs(diff(s)));
            title(annot.ts_name{i},'Interpreter','none');xlabel('s');grid on;
            saveas(f,[path annot.ts_name{i} '.png']);
           
    end
end
    
end
