% -------------------------------------------------------------------------
% Course: Hydrology for Engineers
% Assignment 1
% Part 1: Process rainfall data from MeteoSwiss
% -------------------------------------------------------------------------

clear variables %clear the workspace variables
close all %close alla figures
clc %clear the command window

% -------------------------------------------------------------------------
% # 1-3: Data import and cleaning
% useful functions: readtable, isnan, year, month
% -------------------------------------------------------------------------

% import data into table T
T = readtable('data.txt',...
    'HeaderLines', 2,...
    'Format','%s%s%f',... %the format is: text string, text string and float number
    'TreatAsEmpty','-'); %this is how empty data is reported (see legend)

% Create a vector h containing the hourly precipitation and a vector t
% containing the timestamp
h = T.rre150h0;    %rre150h0 is the MeteoSwiss code for hourly rainfall depth [mm]
t = datetime(T.time,'InputFormat','yyyyMMddHH'); %convert to datetime (can be slow)
m = month(t); %gives a value in 1-12 to indicate the month of each date
y = year(t); %gives the year of each date

% fix empty values (which appear as NaN values in the Matlab)
emptyValues = isnan(h); %logical test to tell whether a value is missing or not
h(emptyValues) = 0; %give zero to those values
fprintf('%i empty values\n', sum(emptyValues)); %display how many missing values there are


% -------------------------------------------------------------------------
% # 4: Plot with annual rainfall over the years
% -------------------------------------------------------------------------

j = 0; %index pour la pluie tot annuel
for i = 1:1:length(t)
    if i == length(t) %dernière element
        Pyear(i) = h(i);
        j = j + 1;
        Pyears(1,j) = year(t(i));
        Pyears(2,j) = sum(Pyear);
    elseif year(t(i+1)) == year(t(i)) % même année 
        Pyear(i) = h(i);
    else                % changement année
        j = j + 1;
        Pyear(i) = h(i); % dernière donnée de l'année
        Pyears(1,j) = year(t(i));
        Pyears(2,j) = sum(Pyear);
        Pyear = [];
    end
end

% ...
% ...
% ...

axex = Pyears(1, :);
axey = Pyears(2, :);
figure(1)
bar(axex,axey,'red')
grid on
title('Annual total precipitations')
xlabel('Years')
ylabel('Precipitation [mm]')
xlim([1978,2021])
saveas(gcf,'1.png')
% 
% %5
% %Compute rainfall maxima of a certain duration
% rainmax = 0;
% for i=1:1:length(h)-2
%     sum = h(i) + h(i + 1) + h(i + 2);
%     if sum > rainmax
%         rainmax = sum;
%     end
% end
% 
% %6
% %Compute rainfall maxima of a certain duration over a year:

%7
%Extend to multiple years and multiple durations
nombreyears = length(Pyears);
duration  = [1 3 6 12 24 48];
for i = 1:1:nombreyears %years
    year = Pyears(1,i);
    days_year = h(y==year);
    Max = 0;
    for j = 1:1:length(duration) %duration
        n = duration(j);
        for k = 1:1:length(days_year)-(n-1) %année
            Sum = sum(days_year(k:k+n-1));
            if Sum > Max
                Max = Sum;
            end
        end
        AnnualMax(i,j) = Max;
    end
end

D =  duration;
%8

save('assignment1_output_part1.mat','D','AnnualMax');

display('finished')









