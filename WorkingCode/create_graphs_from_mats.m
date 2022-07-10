clear; clc; close all;

directions = ["Left" "Right"];
people = ["alexei" "reva" "dani" "sahil" "david"];
numbers = ["1" "2" "3" "4" "5"];


for i=1:1:5
    for j=1:1:2
        for k=1:1:5
%             disp([people(k) directions(j) numbers(i)]);
            file_name = strcat("user_data/students/", people(k), "/", directions(j), "-", numbers(i), ".mat");
            save_directory = strcat("graphs/");
                
            try
                file = load(file_name);
                disp(file)
                
%                 samples = file.person.samples;
%                 disp("work 2")
%                 config = gcf;
%                 disp("work 3")
%                 figure; plot(samples);
%                 disp("work 4")
%                 exportgraphics(config, strcat('graphs/',people(k), '/', directions(j), '-', string(numbers(i), '.png')));
                

            catch
                disp(strcat("Failed for ", people(k), " ", directions(j), " ", numbers(i)));
            end
%             disp(x.samples)
% %             figure('Name', strcat(people(k), "/", directions(j), "-", numbers(i))); plot(x);
% 
%             
%             f = gcf;
%             
%             % Requires R2020a or later
%             exportgraphics(f,strcat('graphs/',people(k), '-', directions(j), '-', string(numbers(i)), '.png'),'Resolution',300)
        end
    end
end