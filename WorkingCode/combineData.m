function [chirp] = get_chirp_interval(chirp_num, total_mic_data)
    chirp = total_mic_data(1200*(chirp_num-1) + 1 : 1200*(chirp_num)-1);
end

