
% Function for segmentation of structure-borne data into individual chirps
% based on the index of the array and the chirp number 
function [chirp] = get_chirp_interval(chirp_num, total_mic_data)

    chirp = total_mic_data(1200*(chirp_num-1) + 1 : 1200*(chirp_num)-1);

end