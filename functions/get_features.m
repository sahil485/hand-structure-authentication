function [avg, std_data, max_data, min_data, ...
    rge, variance, change, q1, q2, q3, q4, ...
    skew, kurt, ...
    power, mfcc_data, fbe, frames] = get_features(sequence)

    avg = mean(sequence); std_data = std(sequence);
    
    max_data = max(sequence); min_data = min(sequence);
    
    rge = range(sequence); variance = var(sequence);
    
    change = [];
    [~,index] = size(sequence);
    for i = 1:index
%         disp(i);
        temp = findchangepts(sequence(:,i));
        change = [change temp'];
    end
    
    q1 = quantile(sequence, 0.25); q2 = quantile(sequence, 0.5);
    q3 = quantile(sequence, 0.75); q4 = quantile(sequence, 1);
    
    skew = skewness(sequence); kurt = kurtosis(sequence);

    fft_data = fftshift(fft(sequence,256));
    power = abs(fft_data).^2/length(fft_data);

    [mfcc_data, fbe, frames_raw] = get_freq_data(sequence);

    frames = mean(abs(frames_raw));

end