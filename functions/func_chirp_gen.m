<<<<<<< HEAD
%function [return matrix] = func_name(input matrix)


function [signal_full, signal_duplicate, starter_pilot] = ...
    func_chirp_gen(freq_sam , freq_set, chirp_time, window_len, ... %freq_sam = 48e3, freq_set = [min min+1 min+2 min+3 ... max], chirp_time = 0.025, window_len = 0.25
    how_many_reps_per_freq, how_many_reps_per_signal) %rep_per_freq = 2, reps_per_signal = 4

%
=======

function [signal_full, signal_duplicate, starter_pilot] = ...
    func_chirp_gen(freq_sam, freq_set, chirp_time, window_len, ...
    how_many_reps_per_freq, how_many_reps_per_signal)

>>>>>>> sahil
% Generate a chirp signal. Accepts parameters for sampling frequency,
% frequency set (min and max frequencies), chirp time (how long the
% chirp lasts in milliseconds, window length (percentage of the signal
% to envelope in Hanning window, and number of repetitions for frequency
% (if you want multiple chirps of a given frequency, and number of
% repeitions for the signal (if you want the entire signal to repeat)

chirp_samples = 0:1/freq_sam:chirp_time; chirp_samples(end) = []; % Samples based on fs and time
<<<<<<< HEAD
%matrix from 0 to 0.025 with 1/freq_sam-size intervals - this takes into
%account the sampling frequency with the 48e3 samples taken which is why
%the vector has intervals of 1/48e3

%% Envelope 

%In physics and engineering, the envelope of an oscillating signal is a smooth curve outlining its extremes. 
% The envelope thus generalizes the concept of a constant amplitude into an
% instantaneous amplitude. Outlines the boundaries of the curve

=======

%% Envelope 
>>>>>>> sahil
if window_len > 0.50 || window_len < 0 
    window_len = 0.50;
end
window_sam = length(chirp_samples)*window_len; % Number of samples in window
<<<<<<< HEAD
%window_sam = 1200 * 0.5 = 600
% 50% of the chirp samples (1200*0.5) are going to be recorded in the
% Hanning window
window_sig = 0:1/window_sam:1; window_sig(end) = []; % Envelope for chirp
% from 0 to 1 with increments of 1/window_sam - creates the actual envelope
% to gradually increase the frequency



% datapoints 

%% Repeating Chirp Signal
%freq_set = [min min+1 min+2 min+3 ... max]
signal_full = [];
for i = 1:length(freq_set)
    chirp_freq = freq_set(i); % Choose frequency
    signal = chirp(chirp_samples,chirp_freq,chirp_time,chirp_freq); % Single Chirp - chirp(intervals, freq_start, time, freq_end)
    %in these case, the chirp is a constant frequency that does not change
    %but happens 48e3 times in 25 ms
    %swept cosine chirp means that the frequency of the signal is increased
    %logarithmcally with time to encompass all frequencies from the
    %beginning to the ending frequency 
   

    signal(1:length(window_sig)) = signal(1:length(window_sig)).*window_sig; % Envelope Front
    signal(end+1-length(window_sig):end) = signal(end+1-length(window_sig):end).*fliplr(window_sig); % Envelope End
    disp(signal)
%    figure; plot(chirp_samples, signal); % plots the signal spectrogram
%    figure; spectrogram(signal,[],[],[],freq_sam,'power','yaxis'); % plots the signal spectrogram
%    the freq
=======
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
>>>>>>> sahil

    signal_tail = [signal zeros(1, length(signal))]; % Add space between chirp repetitions
%     chirp_time_new = 0.025*2; % Single chirp duration in ms
%     chirp_samples_new = 0:1/freq_sam:chirp_time_new; chirp_samples_new(end) = [];
%     figure; plot(chirp_samples_new, signal_tail);
%     figure; spectrogram(signal_tail,[],[],[],freq_sam,'power','yaxis'); 
    
<<<<<<< HEAD
    for j = 1:how_many_reps_per_freq-1 %% Consecutive chirps may have the same frequency
        signal_tail = [signal_tail signal_tail];
    end
    signal_full = [signal_full signal_tail];
=======
%     disp(how_many_reps_per_freq)
    for j = 1:how_many_reps_per_freq-1 %% Consecutive chirps may have the same frequency
        signal_tail = [signal_tail signal_tail];
    end
%     disp(signal_tail);
    signal_full = [signal_full signal_tail];
%     disp(signal_full)
%     disp(['signal full', signal_full]);
>>>>>>> sahil
end

%% Duplicate the repeating chirp signal, to make experiments faster
signal_duplicate = signal_full;

<<<<<<< HEAD
starter_pilot = chirp(chirp_samples,22e3,chirp_time,22e3); %create a chirp with a frequency of 22 kHz for 0.025
starter_pilot = [starter_pilot starter_pilot starter_pilot]; %three chirps with that frequency
=======
starter_pilot = chirp(chirp_samples,22e3,chirp_time,22e3);
starter_pilot = [starter_pilot starter_pilot starter_pilot];
>>>>>>> sahil
    
if how_many_reps_per_signal ~= 1
    
    %% Space between repetitions should be 3 x Chirp Time (3600 samples for 3x25ms)
    for k = 1:how_many_reps_per_signal-1
<<<<<<< HEAD
        signal_full = [signal_full zeros(1, length(starter_pilot)) signal_duplicate]; %sets up the spacing in between successive signal transmissions
=======
        signal_full = [signal_full zeros(1, length(starter_pilot)) signal_duplicate];
>>>>>>> sahil
    end

%     figure; plot(signal_full);
end

%% Attach pilot signal to front of signal
<<<<<<< HEAD
zeros(1, length(starter_pilot)); %gives the signal another "break" in the beginning to prevent one continuous frequency
signal_full = [starter_pilot zeros(1, length(starter_pilot)) signal_full]; %pilot signal is used to calibrate the microphone
%after the pilot signal, each chirp signal is sent 

=======
zeros(1, length(starter_pilot));
signal_full = [starter_pilot zeros(1, length(starter_pilot)) signal_full];

% disp(signal_full)
>>>>>>> sahil

end