clear; clc; close all;

% Given an audio file of a person's holding behavior, extract the sequence
% from file by cross correlation. The sequence is then divided by number of
% chirp repetitions and then further by individual chirps. 

%% Set File Name Parameters
disp('Begin');
% Set what audio file to use
% Case and Glove settings should only go with Galaxy Device
% Portrait and Landscape hands should only go with Tablet
file_name = 'p1/Galaxy_Office_R';
save_directory = 'user_data/';

disp(['Processing ' file_name '.wav ...']);

%% Set Parameters to Generate Signal
fs = 48e3; % Sampling frequency (fs)
freq_min = 18e3; freq_max = 22e3; % Min and max frequnecies to transmit

%the frequency must be in a 5e3 kHz range because otherwise the length of
%the array created with chirp_samples exceeds the maximum limit 

number = (freq_max - freq_min)/1e3 + 1;
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
chirp_time = 0.025; % Single chirp duration in ms
window_len = 0.25; % Percentage of chirp to envelope (front and end)

how_many_reps_per_freq = 2; % Choose 1 for no extra repetitions
how_many_reps_per_signal = 4; % Choose 1 for no extra repetitions

[signal_full, signal_duplicate, pilot] = ...
    func_chirp_gen(fs, freq_set, chirp_time, window_len, ...
    how_many_reps_per_freq, how_many_reps_per_signal);

%%UP TILL THIS POINT - CREATING THE SIGNAL FROM STEP 1

%% Final signal for cross correlation

%*****

chirp_sig = signal_full'; %' the complex conjugate transpose of the full signal - what is point of making this transformation

freq_range = [freq_set(1), freq_set(end)];

% Possible to skip all code above using this line below, but some variables
% calculated above are useful
% chirp_sig = audioread('chirp_18khzto22khz_48khzfs_25ms_repeat2.wav');


%% Cross Correlation to find signal in recording
disp('Filtering...');

[x,~] = audioread([file_name '.wav']); % loading the microphone data to 
% cross correlate with the basic signal created above
%reading in the audio file to x and ignoring the second return value

%stereo recording has both left and right recording - the audio file has
%both left and right channels, so this is using only one of the channels

mic_a = bandpass(x(:,1), freq_range, fs);
%y = bandpass(x,fpass,fs) specifies that x has been sampled at a rate of 
% fs hertz. The two-element vector fpass specifies the passband frequency range of the filter in hertz.

%*this bandpass filter removes all frequencies outside of the min-max range
%from the recording 

[acor_a, lag_a] = xcorr(mic_a, chirp_sig); %cross correlates the left stereo signal and the generated chirp signal
% returns the cross correlation matrix and the lags in the calculation 
% when the cross correlation was being calculated, one signal is lagging
% behind another at lag_a samples behind

% Normal Cross-correlation to find signal in recording
try
    [~,Ia] = max(abs(acor_a)); % Find the index of max value in autocorr - this is where the structure-borne signal starts 
    % Ia is the index of the max correlation - exact time stamp during the
    % signal

    start = lag_a(Ia); %start at the lag where the structure-borne signal starts 
    %why are the lags being used to find the start point of the signal?

    %mic_a - holds the bandpass filtered frequencies within the desired
    %range of the left microphone channel

    mic_a = mic_a(start:start+length(chirp_sig)-1); % chirp extracted from file
    mic_a = mic_a(length(pilot)+1:end); % Remove pilot from front

    mic_a = mic_a'; %complex conjugate transpose again

% If cross_correlation overestimates the start point, try to find next best
% starting point. There should be no 'tail' at the end of the plot of mic.

catch % the catch statement would execute if the "start" variable is found to be too "late" in the signal - in this case, 
    %that would cause an indexing error for the assignment in line 99.
    disp('Automated filtering failed...');
    disp('Manual supervision required...');
    [~,z] = sort(abs(acor_a)); %sort acor_a from min to max
    cc_counter = 1; %counter to track which proposed trim to use
    for j = 1:length(chirp_sig)
        z_start = lag_a(z(j)); %find the maximum of lag_a
        z_ending = z_start+length(chirp_sig)-1;
        if z_ending < length(mic_a) && z_start > 0
            figure; plot(mic_a(z_start:z_ending));
            usr_cont = input(['#' num2str(cc_counter) ...
                ' @ Index ' num2str(z(j)) ': Enter 1 to continue, 0 to stop: ']);
            cc_counter = cc_counter+1;
            if usr_cont ~= 1
                close all; 
                break
            end
        end
    end

    mic_a = mic_a(z_start:z_ending); % chirp extracted from file
    mic_a = mic_a(length(pilot)+1:end); % Remove pilot from front
    mic_a = mic_a';
end
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% IMPORTANT - VERIFY THE PLOT OF THE FILTERED SIGNAL BELOW %
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
figure; plot(mic_a);


%% Data structure for signals

%separates the different signals sent by the speaker and puts them into a
%2D array where every row being its own signal of 10 chirps 

disp('Segmenting chirp chains...');
% Main output are the samples and samples_chirps variables
% The only parameter to monitor in this part is samples_num
samples_start = length(pilot);
samples_gap = length(signal_duplicate);
samples_end = samples_start+samples_gap;

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %
% IMPORTANT - DON'T FORGET TO CHECK samples_num IS CORRECT %
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %

samples_num = how_many_reps_per_signal; % number of repeating signals in file
% If number is less than real value, you will be missing data
% If number is greater than real value, your index will be out of bounds
samples = zeros(samples_num, samples_gap); % preallocate space

% this is the logic the for loop is doing
% samples1 = mic_a(0*samples_gap+1*samples_start+1:1*samples_end);
% samples2 = mic_a(1*samples_gap+2*samples_start+1:2*samples_end);
% samples3 = mic_a(2*samples_gap+3*samples_start+1:3*samples_end);
% samples4 = mic_a(3*samples_gap+4*samples_start+1:4*samples_end);

% each row of samples is one full signal (10 short chirps)
for i=1:samples_num
    samples(i,:) = mic_a((i-1)*samples_gap+i*samples_start+1:i*samples_end);
end

disp('Segmenting individual chirps...');
samples_points = 1200; % 1200 points in single chirp
samples_num_chirps = samples_num*10; % number of chirps in sample, 10 chirps per sample
samples_chirps = zeros(samples_num_chirps, samples_points); % preallocate space

% this is the logic the for loop is doing
% samples1 = samples(1,0*samples_points+1:1*samples_points);
% samples2 = samples(1,2*samples_points+1:3*samples_points);
% samples3 = samples(1,18*samples_points+1:19*samples_points);

sc_counter = 1; % counter to add chirps to matrix correctly
% need dedicated counter because for loop does not increment by 1

% each row of samples_chirps is one of the individual chirps (10 per row of
% samples)
for j = 1:samples_num
    for i = 1:2:20 % Up to 20 because there are only 10 chirp repetitions
        % Doubled because we are incrementing by 1200 pt samples, not 2400
        % (buffer is ignored)
       samples_chirps(sc_counter,:) = samples(j,(i-1)*samples_points+1:i*samples_points); %1200 sample data points
       sc_counter = sc_counter+1;%refers to the signal #
    end
end

%saving the data

%% Save Filtered Signal Data
disp('Saving Data...');

person = profile;
person.samples = samples; person.samples_chirps = samples_chirps;
if ~exist(save_directory, 'dir')
       mkdir(save_directory);
end
save([save_directory file_name], 'person');

%% End Program
disp('Done!');
