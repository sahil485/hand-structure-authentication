clc; clear; close all;

%% Set Parameters to Generate Signal
fs = 48e3; % Sampling frequency (fs)
freq_min = 15e3; freq_max = 22e3; % Min and max frequnecies to transmit
number = (freq_max - freq_min)/1e3 + 1;
%disp(number)
freq_set = zeros(1, number); % Preallocate space for frequencies
freq_dex = 1; % Index counter for freq_set

%% This loop creates set of frequencies of chirps
%% See the freq_set variable in workspace
%% No need to modify variables here
for i=freq_min:1e3:freq_max % Loop in steps of 1k
    freq_set(freq_dex) = i;
    freq_dex = freq_dex+1;
end

%% Parameters continued
chirp_time = 0.025; % Single chirp duration in s
window_len = 0.25; % Percentage of chirp to envelope (front and end)

%number of chirp signals per frequency
how_many_reps_per_freq = 2; % Choose 1 for no extra repetitions
%number of frequency sweeps per file
how_many_reps_per_signal = 5; % Choose 1 for no extra repetitions

%% Create signal here
[signal_full, signal_duplicate, starter_pilot] = ...
    func_chirp_gen(fs, freq_set, chirp_time, window_len, ...
    how_many_reps_per_freq, how_many_reps_per_signal);

%% Plot signals here
figure; plot(signal_full);
figure; spectrogram(signal_full,[],[],[],fs,'power','yaxis'); 

%% Save file
% audiowrite('chirp_18khzto22khz_48khzfs_25ms_repeat2.wav', signal_full, fs);