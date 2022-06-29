GSET MATLAB FILES

FOLDERS
* classes: contains data structures to organize data
* functions: contains functions to calculate signal information
* recordings: contains audio files from user authentication experiments, subfolders for individual users
* transmissions: contains chirp audio files transmitted by mobile device
* user_data: contains matlab variable files storing features for each user

CLASSES
* profile.m: structure for user data, holds user-influenced chirp signal and features extracted

FUNCTIONS
* func_chirp_gen.m: generates chirp signal based on parameters provided to it
* get_features: calculates time domain features when given user-influenced chirp signal
* get_freq_data: calculates frequency domain features such as mfcc, called by get_features
* mfcc.m: calculates mfcc variables
* trifbank.m: used by mfcc.m
* vec2frames.m: used by mfcc.m

MATLAB PROGRAMS <--- THIS IS THE REALLY IMPORTANT STUFF 
* Step 1: create_chirp.m: choose what type of chirp signal to create, saves .wav file
* Step 2: cross_correlate.m: select audio file from audio folder and extract user-influenced signal from recording, creates profile
** Step 2 (Alternate): thresholding.m: cross_correlate may sometimes incorrectly calculate the user signal, thresholding is simpler method
* feature_extraction.m: given user profile, calculate the features, saves user data into profile
* learning.m: compiles all desired profiles into one data structure for classification learner app

CLASSIFICATION LEARNER APP <--- ALSO REALLY IMPORTANT
* In MATLAB, open the APPS tab at the top of the screen
* Click the Classification Learner icon (looks like bunch of red and blue dots)
* Start a new learning session by loading your desired workspace data (master_data created by learning.m)
* ???
* profit
