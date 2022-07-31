# "A Hand Structure-Based Mobile Authentication Solution to the Security-Reliability Trade-off"

# Authors: 
## Sahil Chatiwala, Reva Hajarnis, Alexei Korolev, Danielle Park, David Shenkerman, Dr. Yingying Chen, and Yilin Yang (PhD Student)

### Folders:
* classes: contains data structures to organize data
* functions: contains functions to calculate signal information
* graphs: contains MATLAB figures for transmissions, signals, segments, and chirps of each subject
* recordings: contains audio files from user authentication experiments, subfolders for individual users
* transmissions: contains chirp audio files transmitted by mobile device

### Classes:
* profile.m: structure for user data, holds user-influenced chirp signal and features extracted

### Functions:
* create_graphs_from_mats.m: creates graphs of segmented chirps based on array index range specified as parameters
* func_chirp_gen.m: generates chirp signal based on parameters provided to it
* get_chirp_interval.m: returns array indices of the nth chirp specified as a parameter; used with create_graphs_mats.m
* get_features: calculates time domain features when given user-influenced chirp signal
* get_freq_data: calculates frequency domain features such as mfcc, called by get_features
* mfcc.m: calculates mfcc variables
* trifbank.m: used by mfcc.m
* vec2frames.m: used by mfcc.m

### MATLAB Programs:
* Step 1: create_chirp.m: choose what type of chirp signal to create, saves .wav file
* Step 2: cross_correlate.m: select audio file from audio folder and extract user-influenced signal from recording, creates profile
* Step 3: feature_extraction.m: given user profile, calculate the features, saves user data into profile
* Step 4: learning.m: compiles all desired profiles into one data structure for Classification Learner's Application

### Classification Learners Application
* In MATLAB, open the APPS tab at the top of the screen
* Click the Classification Learner icon (looks like bunch of red and blue dots)
* Start a new learning session by loading your desired workspace data (master_data created by learning.m)
* Models were developed by experimenting with different architectures and modifying false validation costs to help the models specialize for different authentication scenarios
