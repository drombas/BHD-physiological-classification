function [t, s] = crop_signal(t0, s0, t_start, t_end)

window = t0>=t_start & t0<=t_end;

t = t0(window);

if any(size(s0) == 1)  %  array
    s = s0(window);
else
    s = s0(window,:);
end