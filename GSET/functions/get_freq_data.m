function [result_mfcc,result_fbe,result_frames] = get_freq_data(signal)

    %mfcc parameters
    Tw = 20;                % analysis frame duration (ms)
    Ts = 2.5;               % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 32;                 % number of filterbank channels
    C = 13;                 % number of cepstral coefficients0
    L = 22;                 % cepstral sine lifter parameter
    LF = 18000;             % lower frequency limit (Hz)
    HF = 24000;             % upper frequency limit (Hz)
    Fs = 48000;

    % % mfcc test
    result_mfcc = []; result_fbe = []; result_frames = [];
    for i = 1:size(signal, 2)
        [temp_mfcc, temp_fbe, temp_frames] = mfcc(signal(:,i), Fs, Tw, Ts, alpha, @hamming, [LF HF], M, C, L);
        data_mfcc = mean(abs(temp_mfcc)')'; data_fbe = mean(abs(temp_fbe)')'; data_frames = mean(abs(temp_frames)')';
        result_mfcc = [result_mfcc data_mfcc];
        result_fbe = [result_fbe data_fbe];
        result_frames = [result_frames data_frames];
    end
end