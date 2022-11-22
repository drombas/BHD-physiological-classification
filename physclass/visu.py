""" Visualization functions used across the codebase.

David Romero-Bascones, dromero@mondragon.edu
Biomedical Engineering Department, Mondragon Unibertsitatea, 2022
"""
import matplotlib.pyplot as plt
import numpy as np


def fig_spectrum(X):
    "Visualize the frequency spectrum of each signal type."


def fig_signals(s_crop, s_norm, s_filt, tw, sp):
    "Visualize several signals."
    fig, axs = plt.subplots(3, 1, figsize=(22, 8))
    for i, sp in enumerate([s_crop, s_norm, s_filt]):
        axs[i].plot(tw, sp)
        axs[i].set_xlim([0, tw.max()])
        axs[i].set_ylim([sp.min(), sp.max()])
        axs[i].grid()
        axs[i].set_xlabel('s')


def fig_min_max(tw, s_filt, minima, maxima):
    fig, ax = plt.subplots(1, 1, figsize=(22, 6))
    ax.plot(tw, s_filt, linewidth=2, color='cornflowerblue', zorder=-1)
    ax.scatter(tw[maxima], s_filt[maxima], color='red')
    ax.scatter(tw[minima], s_filt[minima], color='lime')
    ax.grid()
    ax.set_xlabel('s')


def fig_zoom_in(tw, minima, maxima, s_filt):
    """Generate a close figure of one signal period to illustrate the feature
    computation."""
    fig, ax = plt.subplots(1, 1, figsize=(22, 6))
    #ax.plot(tw, s_filt, linewidth=4, color='cornflowerblue', zorder=-1)

    ax.plot([tw[maxima[0]], tw[minima[0]]], [s_filt[maxima[0]],
            s_filt[minima[0]]], color='black', linestyle='dashed', zorder=1)
    ax.plot(tw[maxima[0]:minima[0]], s_filt[maxima[0]:minima[0]],
            linewidth=4, color='pink', zorder=1)
    ax.plot(tw[0:maxima[0]], s_filt[0:maxima[0]],
            color='cornflowerblue', linewidth=4, zorder=1)
    ax.plot(tw[minima[0]:-1], s_filt[minima[0]:-1],
            color='cornflowerblue', linewidth=4, zorder=1)

    ax.scatter(tw[maxima], s_filt[maxima], 200, color='red', zorder=2)
    ax.scatter(tw[minima], s_filt[minima], 200, color='lime', zorder=2)
    ax.grid()
    ax.set_xlabel('s', fontsize=16, fontweight='bold')
    ax.xaxis.set_tick_params(labelsize=16)


def fig_classifier_results(X1, X2, Y, acc):
    """Visualize the 3-way classifier results."""
    x2_th = -0.18
    x1_th = 0.13

    x1_min = np.min(X1) - 0.01
    x1_max = np.max(X1) + 0.01
    x2_min = np.min(X2) - 0.01
    x2_max = np.max(X2) + 0.01

    fig, axs = plt.subplots(1, 1, figsize=(8, 8))

    ts_types = ['chest', 'O2', 'CO2']

    for ts_type in ['respiratory_chest', 'respiratory_O2', 'respiratory_CO2']:
        is_type = Y == ts_type
        axs.scatter(X1[is_type], X2[is_type], zorder=2)
    axs.legend(ts_types, fontsize=18)

    axs.plot([x1_min, x1_max], [x2_th, x2_th], linestyle='dashed',
             linewidth=2, color='red', zorder=1)
    axs.plot([x1_th, x1_th], [x2_th, x2_max], linestyle='dashed',
             linewidth=2, color='magenta', zorder=1)
    axs.grid()
    axs.set_xlabel('X1', fontsize=16, fontweight='bold')
    axs.set_ylabel('X2', fontsize=16, fontweight='bold')
    axs.set_xlim([x1_min, x1_max])
    axs.set_ylim([x2_min, x2_max])
    props = dict(boxstyle='round', facecolor='white', alpha=1)
    axs.text(0.2, -0.05, f'ACC: {acc} %', fontsize=16,
             verticalalignment='top', bbox=props)
    axs.xaxis.set_tick_params(labelsize=16)
    axs.yaxis.set_tick_params(labelsize=16)
