%chirp_samples = 0:1/48e3:0.025; chirp_samples(end) = [];
%disp(chirp_samples)

%signal = chirp(chirp_samples, 18e3, 0.025, 19e3);

%spectrogram(signal)

%figure; spectrogram(signal_full,[],[],[],fs,'power','yaxis'); 

arr = zeros(1,5);

for i = 1:1:5
    arr(i) = i;
end

disp(arr)

range = [arr(1), arr(end)];
disp(range)
