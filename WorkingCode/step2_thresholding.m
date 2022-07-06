clear; clc; close all;

dir = 'recordings/';
name = 'p1/Galaxy_Office_R';
file_received = [dir name '.wav'];

%% Parameters of the Transmitted Signal
%these values should not change unless you are transmitting a different signal
file_transmit = 'chirp_18khzto22khz_48khzfs_25ms_repeat40.wav';
param_freq_range = [18e3, 22e3];
param_len_pilot = 3600;
%signal consists of 10 chirps
param_len_signal = 24e3; %length of 10 chirps plus gap following each chirp
param_len_chirp = 1200; %length of 1 chirp
param_len_sbuffer = 3600; %length of buffer between signals
param_len_cbuffer = 1200; %length of buffer between chirps
param_num_signals = 40; %how many signals exist in recording
param_num_chirps = 400;
[param_chirp_sig, param_fs] = audioread(file_transmit);

%% Find Transmission in Recording
[x,~] = audioread(file_received); % read sequence from filename

mic_a = bandpass(x(:,1), param_freq_range, param_fs); % filter frequencies

threshold_remove = 0.001; %anything below threshold set to 0 (empty noise)
mic_a(abs(mic_a)<threshold_remove) = 0; 
mic_a = mic_a .* double(abs(mic_a)>threshold_remove); 

for i = 1:length(mic_a) %find the first nonzero element, should be signal start
   if mic_a(i) ~= 0
      mic_a = mic_a(i:end); 
      break
   end
end
disp('Calculated Signal Start Index = ');
disp(i)
plot(mic_a) %check that pilot was located correctly

mic_a = mic_a( ...
    param_len_pilot+param_len_sbuffer+1: ... %cut pilot and buffer
    length(param_chirp_sig)-1 ... %cut empty noise at end
    ); % chirp extracted from file

mic_a = mic_a';

%% Extract Signals from Recording
%pre-allocate space for all signals to be found in recording
samples = zeros(param_num_signals, param_len_signal);
samples_index = 1; %keep track of index in pre-allocated space

%extract the first signal in recording
for j = 1:length(mic_a) %find the first nonzero element, should be signal start
    if mic_a(j) ~= 0
        mic_a = mic_a(j:end);
        break
    end
end
samples(samples_index,:) = mic_a(1:param_len_signal); %cut first signal
remains = mic_a(param_len_signal+1:end); %the remaining recording after cut
samples_index = samples_index+1; %increment index

% go through remains of recording until all signals found
while (length(remains)>param_len_signal)
    for i = 1:length(remains) %find the first nonzero element, should be signal start
        if remains(i) ~= 0
          remains = remains(i:end); 
          break
       end
    end

    try
        samples(samples_index,:) = remains(1:param_len_signal);
        remains = remains(param_len_signal+1:end);
    catch
        fill_the_gap = abs(param_len_signal-length(remains));
        remains = [remains zeros(1,fill_the_gap)];
        samples(samples_index,:) = remains;
    end
    
    samples_index = samples_index+1;

end

figure; 
for i=1:40
   subplot(4, 10, i); plot(samples(i,:)) 
end

% figure; 
% for i=1:40
%    subplot(4, 10, i); spectrogram(samples(i,:)) 
% end

%% Extract Chirps from Signal

disp('Segmenting individual chirps...');
samples_chirps = zeros(param_num_chirps, param_len_chirp); % preallocate space

% this is the logic the for loop is doing
% samples1 = samples(1,0*samples_points+1:1*samples_points);
% samples2 = samples(1,2*samples_points+1:3*samples_points);
% samples3 = samples(1,18*samples_points+1:19*samples_points);

sc_counter = 1; % counter to add chirps to matrix correctly
% need dedicated counter because for loop does not increment by 1

% each row of samples_chirps is one of the individual chirps (10 per row of
% samples)
for j = 1:param_num_signals
    for i = 1:2:20 % Up to 20 because there are only 10 chirp repetitions
        % Doubled because we are incrementing by 1200 pt samples, not 2400
        % (buffer is ignored)
       samples_chirps(sc_counter,:) = samples(j,(i-1)*param_len_chirp+1:i*param_len_chirp);
       sc_counter = sc_counter+1;
    end
end

% figure; 
% j=37;
% test_chirps = samples_chirps(j:j*10,:);
% for i=1:10
%    subplot(5, 2, i); plot(test_chirps(i,:)) 
% end
% 
% figure; 
% for i=1:10
%    subplot(5, 2, i); spectrogram(test_chirps(i,:)) 
% end
%% Save Filtered Signal Data
disp('Saving Data...');

person = profile;
person.samples = samples; person.samples_chirps = samples_chirps;

save_loc = 'user_data/';
if ~exist(save_loc, 'dir')
       mkdir(save_loc);
end
save([save_loc name '.mat'], 'person');

%% End Program
disp('Done!');