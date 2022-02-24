"""Utilities used for signal processing, feature extraction.

David Romero-Bascones, dromero@mondragon.edu
Biomedical Engineering Department, Mondragon Unibertsitatea, 2022
"""

import numpy as np
from scipy.signal import butter, lfilter


def crop_signal(t, s, t_start, t_end):
    in_window = np.logical_and(t >= t_start, t <= t_end)
    return t[in_window], s[in_window]


def butter_lowpass(cutoff, fs, order=5):
    """Butterworth low pass filter for smoothing.
    code from: https://stackoverflow.com/questions/25191620/...
    ...creating-lowpass-filter-in-scipy-understanding-methods-and-units"""

    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return b, a


def butter_lowpass_filter(data, cutoff, fs, order=5):
    """"Filter a signal using a Butterworth lowpass filter."""
    b, a = butter_lowpass(cutoff, fs, order=order)
    y = lfilter(b, a, data)
    return y


def compute_time_features(t, s, minima, maxima):
    """Compute time-domain features from a signal. These have been manually
    engineered for the especific problem."""
    area_dif_up = []
    area_dif_down = []

    # Upper tidal periods
    # Last minimum require an specific implementation. For now do not explore.
    for i, x1 in enumerate(minima[:-1]):

        t1 = t[x1]
        y1 = s[x1]

        # Next minimum
        x3 = minima[i + 1]
        t3 = t[x3]
        y3 = s[x3]

        # Find maxima in between
        ind_max = np.where(np.logical_and(maxima > x1, maxima < x3))[0]
        if len(ind_max) > 1:
            print("Two maxima located. Continue.")
            continue
        elif len(ind_max) == 0:
            print("No maxima located. Continue.")
            continue
        x2 = maxima[ind_max]
        t2 = t[x2]
        y2 = s[x2]

        # Upper tidal part (min to max)
        x_up = np.arange(x1, x2 + 1)
        t_up = t[x_up]
        y_up = s[x_up]
        y_up_linear = (y2 - y1)/(t2 - t1) * (t_up - t1) + y1

        area_dif_up.append(np.mean(y_up - y_up_linear))

        # Down tidal part (max to min)
        x_down = np.arange(x2, x3 + 1)
        t_down = t[x_down]
        y_down = s[x_down]
        y_down_linear = (y3 - y2)/(t3 - t2) * (t_down - t2) + y2

        area_dif_down.append(np.mean(y_down - y_down_linear))

    return np.mean(area_dif_up), np.mean(area_dif_down)


def compute_pattern_features(s, minima, maxima, n_bins=10, n_points=20):
    """ Focus on up/down tidal periods separately
    Compute the difference between the starting point (x1/up or x2/down) and
    n_points equally spaced. The array of differences is the feature vector!
    Applicable to some sort of K-NN approach

    Work in progress. Not used in this notebook."""

    d = []
    i_min = 1
    # Upper tidal periods
    for min1 in minima:
        # Find next maxima

        # If there are more minima in between --> break

        # Get n_points (just round it, not interpolate)
        # ind = np.linspace(min1, max1, n_point + 2)
        # ind = np.round(ind[1:-1]).astype(int)

        # Compute height difference at n_points (relative difference could work?)
        # d.append(s[ind] - s[min1])
        i_min += 1

    d_mean = np.array(d).mean(0)  # average
    return d_mean
