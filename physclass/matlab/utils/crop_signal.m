function [t, s] = crop_signal(t0, s0, t_start, t_end)
% Crop a time series to the window defined by t_start and t_end.
%
% David Romero-Bascones (dromero@mondragon.edu)
% Biomedical Engineering Department, Mondragon Unibertsitatea, 2022

window = t0>=t_start & t0<=t_end;

t = t0(window);

if any(size(s0) == 1)  %  array
    s = s0(window);
else
    s = s0(window,:);
end