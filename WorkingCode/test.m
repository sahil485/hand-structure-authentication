clear person
base_path = 'C:\Users\Sahil\Projects\GovSchool\TouchBasedAuth\WorkingCode\user_data\one_each\';

people = ["alexei" "sahil" "david"];

for i=1:1:3
    disp(strcat(base_path, '\', people(i), '\Left-1.mat'));
    mkdir(strcat(base_path, '\', people(i), '\individual'));
    load(strcat(base_path, '\', people(i), '\Left-1.mat'));
    for j=1:1:40
        figure("Name", strcat(people(i)," Left-1-", string(j))); plot(person.samples_chirps(1200*(j-1) + 1: 1200*j - 1));
        saveas(gcf, strcat('C:\Users\Sahil\Projects\GovSchool\TouchBasedAuth\WorkingCode\user_data\one_each\', ... 
            people(i), "\individual\Left-1-", string(j)));
    end
end

