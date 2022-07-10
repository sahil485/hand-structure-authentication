
function [signal_full, signal_duplicate, starter_pilot] = ...
    func_chirp_gen(freq_sam, freq_set, chirp_time, window_len, ...
    how_many_reps_per_freq, how_many_reps_per_signal)

% Generate a chirp signal. Accepts parameters for sampling frequency,
% frequency set (min and max frequencies), chirp time (how long the
% chirp lasts in milliseconds, window length (percentage of the signal
% to envelope in Hanning window, and number of repetitions for frequency
% (if you want multiple chirps of a given frequency, and number of
% repeitions for the signal (if you want the entire signal to repeat)

chirp_samples = 0:1/freq_sam:chirp_time; chirp_samples(end) = []; % Samples based on fs and time

%% Envelope 
if window_len > 0.50 || window_len < 0 
    window_len = 0.50;
end
window_sam = length(chirp_samples)*window_len; % Number of samples in window
window_sig = 0:1/window_sam:1; window_sig(end) = []; % Envelope for chirp

%% Repeating Chirp Signal
signal_full = [];
for i = 1:length(freq_set)
    chirp_freq = freq_set(i); % Choose frequency
    signal = chirp(chirp_samples,chirp_freq,chirp_time,chirp_freq); % Single Chirp
    signal(1:length(window_sig)) = signal(1:length(window_sig)).*window_sig; % Envelope Front
    signal(end+1-length(window_sig):end) = signal(end+1-length(window_sig):end).*fliplr(window_sig); % Envelope End

%     figure; plot(chirp_samples, signal);
%     figure; spectrogram(signal,[],[],[],freq_sam,'power','yaxis'); 

    signal_tail = [signal zeros(1, length(signal))]; % Add space between chirp repetitions
%     chirp_time_new = 0.025*2; % Single chirp duration in ms
%     chirp_samples_new = 0:1/freq_sam:chirp_time_new; chirp_samples_new(end) = [];
%     figure; plot(chirp_samples_new, signal_tail);
%     figure; spectrogram(signal_tail,[],[],[],freq_sam,'power','yaxis'); 
    
%     disp(how_many_reps_per_freq)
    for j = 1:how_many_reps_per_freq-1 %% Consecutive chirps may have the same frequency
        signal_tail = [signal_tail signal_tail];
    end
%     disp(signal_tail);
    signal_full = [signal_full signal_tail];
%     disp(signal_full)
%     disp(['signal full', signal_full]);
end

%% Duplicate the repeating chirp signal, to make experiments faster
signal_duplicate = signal_full;

starter_pilot = chirp(chirp_samples,22e3,chirp_time,22e3);
starter_pilot = [starter_pilot starter_pilot starter_pilot];
    
if how_many_reps_per_signal ~= 1
    
    %% Space between repetitions should be 3 x Chirp Time (3600 samples for 3x25ms)
    for k = 1:how_many_reps_per_signal-1
        signal_full = [signal_full zeros(1, length(starter_pilot)) signal_duplicate];
    end

%     figure; plot(signal_full);
end

%% Attach pilot signal to front of signal
zeros(1, length(starter_pilot));
signal_full = [starter_pilot zeros(1, length(starter_pilot)) signal_full];

% disp(signal_full)

end