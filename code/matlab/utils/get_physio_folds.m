function folds = get_physio_folds(labels, n_fold, seed)

N = length(labels); % number of signals

rng(seed);

ind_ts = randperm(N/4); % number of signals of each type

folds = cell(1, n_fold);

n_per_fold = N/n_fold;

for i_fold=1:n_fold
    ind_fold = ind_ts(1:n_per_fold + n_per_fold*(i_fold-1))';
    folds{i_fold} = [ind_fold*4 -3; ind_fold*4-2; ind_fold*4-1; ind_fold*4];
end



