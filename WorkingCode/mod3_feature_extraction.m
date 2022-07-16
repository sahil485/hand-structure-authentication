clear; clc; close all;

directions = ["Left" "Right"];
people = ["alexei" "reva" "dani" "sahil" "david"];
numbers = ["1" "2" "3" "4" "5"];


% Perform feature extraction on all user profiles in a given folder. Simply
% provide the user ID for the files_num variable.

for c=1:1:5
    files_dir = strcat("user_data/students/", people(c), "/");
%         file_name = strcat("students/", people(k), "/", directions(j), "-", numbers(i));
%         save_directory = 'user_data/';
%         files_num = 'p2';
%         files_dir = ['user_data/' files_num '/'];
    
    files = dir(files_dir);
    disp(files)
    files = {files(3:end).name}';
    disp(files)
    files = string(files);
    
    disp(length(files));

    for i=1:length(files)
        disp(strcat('(', num2str(i), '/', num2str(length(files)),')'));
        disp(strcat("Extracting features for ", files_dir, files(i)));
        
        disp(files_dir)
%         load(strcat(files_dir char(files(i)) )));
        load(strcat(files_dir, files(i)))
        
        [...
            person.average, person.std, ...
            person.max, person.min, ...
            person.rge, person.variance, ...
            person.change, ...
            person.q1, person.q2, person.q3, person.q4, ...
            person.skew, person.kurt, ...
            person.fft, person.mfcc, ...
            person.fbe, person.frames ...
            ] = get_features(person.samples_chirps');
        
%         disp(person.samples);
%         figure("Name", strcat(files_dir, files(i))); plot( [, person.samples);
%           disp(size(person.samples))

        person.features = [...
            person.average; person.std; ...
            person.max; person.min; ...
            person.rge; person.variance; ...
            person.change; ...
            person.q1; person.q2; person.q3; person.q4; ...
            person.skew; person.kurt; ...
            person.fft; person.mfcc; ...
            person.fbe; person.frames ...
            ];
        
        save(strcat(files_dir, files(i)), 'person');
        clear person;
    end
end


disp('Done!');