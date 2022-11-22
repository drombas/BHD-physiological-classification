% Prepare EuskalIBUR datase
% - undersample (raw data has 10 kHz sampling rate!)
% - from double to single
% - from BIDS to csv
close all; clc; clearvars;

in_dir = 'F:/dromero/physiology/EuskalIBUR/source';

subjects = {'sub-001','sub-002','sub-003','sub-004','sub-007','sub-008','sub-009'};
n_sub = length(subjects);

fs = 20; % 20 Hz

T_meta   = struct;
Signals = {};
i = 1;

n_ses = 10;
for i_sub=1:n_sub
    sub = subjects{i_sub};
    for i_ses=1:n_ses
        ses = sprintf('ses-%02d', i_ses);

        % Read json
        fname = sprintf('%s/%s/%s/func/%s_%s_task-breathhold_physio.json', in_dir, sub, ses, sub, ses);
        if ~exist(fname, 'file')
            warning([fname ' not found']);
            continue;
        end
        header = read_json(fname);
        
        % Read signals
        fname = sprintf('%s/%s/%s/func/%s_%s_task-breathhold_physio.tsv.gz', in_dir, sub, ses, sub, ses);
        if ~exist(fname, 'file')
            warning([fname ' not found']);
            continue;
        end    
        fname2 = gunzip(fname);
        T = readtable(fname2{1},'delimiter','\t','FileType','text');

        % Rename columns
        T.Properties.VariableNames = header.Columns;

        % Save signals
        fs0 = header.SamplingFrequency;
        n_dec = fs0 / fs;

        for i_sig=1:width(T)
            label = header.Columns{i_sig};

            if strcmp(label, 'time')
                continue;
            end

            ts_name = [sub '_' ses '_' label];
            
            T_meta(i).id            =  ts_name;
            T_meta(i).subject       = sub;
            T_meta(i).session       = ses;
            T_meta(i).start_time    = header.StartTime;
            T_meta(i).sampling_freq = fs;
            T_meta(i).label         = label;
        
            s = T.(label);
            Signals{i} = s(1:n_dec:end);

            i = i + 1;
        end 

        fprintf('%s-%s\n', sub, ses);
    end
end

T_meta = struct2table(T_meta);

n_signal = length(Signals);
n_sample = cellfun(@length, Signals);
X = nan(max(n_sample), n_signal);
for i=1:n_signal
    X(1:n_sample(i), i) = Signals{i};
end
X = single(X);
T_signal = array2table(X, 'VariableNames', T_meta.id);

writetable(T_meta, 'F:\dromero\physiology\EuskalIBUR\raw\labels.csv');
writetable(T_signal, 'F:\dromero\physiology\EuskalIBUR\raw\time_series.csv');

function data = read_json(fname)
    fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
    data = jsondecode(str);
end