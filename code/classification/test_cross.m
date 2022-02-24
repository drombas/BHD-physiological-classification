close all;clc;clearvars;

N = 240; % number of signals
n_fold = 10;

ind_ts = randperm(N/4); % number of signals of each type

folds = cell(1, n_fold);

n_per_fold = N/n_fold;

for i_fold=1:n_fold
    ind_fold = ind_ts(1:n_per_fold + n_per_fold*(i_fold-1))';
    folds{i_fold} = [4*ind_fold - 3; 4*ind_fold - 2; 4*ind_fold - 1; 4*ind_fold];
end



