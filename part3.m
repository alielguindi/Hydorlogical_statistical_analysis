% -------------------------------------------------------------------------
% Course: Hydrology for Engineers
% Assignment 1
% Part 3: Construction of depth-duration-frequency (DDF) curves 
% -------------------------------------------------------------------------

clear variables %clear the workspace variables
close all %close alla figures
% clc %clear the command window
% c appartient [1,100] -> c_list = 1:10:100
% f appartient [-1,1] -> f_list = same
% e appartient [1,1] -> e_list = same
% 
% DDF CURVE FOR ONLY RETURN PERIOD T
% 
% 
% 


% FOR EACH T, 3 PARAMETERS (c,e,f)

% -------------------------------------------------------------------------
% # 1: Calibrate the DDF curve parameters
% useful functions: linspace
% -------------------------------------------------------------------------

% import the data from previous part
load assignment1_output_part2.mat 
T = [10, 40, 100];


% you need DDF curves for each return period, so you will have a set of
% parameters for each return period

% define lists of test values for each parameter (e.g.
% c_list=linspace(0,100,3))

% implement the 'brute force' algorithm 
% -implement nested for loops over every parameter combination 
% -in the core of the loop, compute the depths estimated by the DDF curve
%   with the given return periods and parameter combination
% -compute the sum of square errors between the computed dephts and the
%   ones estimated in part 1. 
% -retain the sets that have the lowest sum of squared errors 
% -check if the best-fit errors are lower than the maximal errors given. If
%   not, repeat the loop with a larger amount of test values


%Series of value for each parameter
c = linspace(0,100,100); 
f = linspace(-1,1,100);
e = linspace(0,1,100);

%Q1 : Parameter calibration
err_T = [25 60 120];
for t = 1:length(T)

  for i = 1:length(c);
     for j = 1:length(f);
         for k = 1:length(e);
            h(t,:) = (c(i) .* D) ./ (D.^e(k) +f(j));
            err_temp = sum((h(t,:)-H_Gum(t,:)).^2);

             if err_temp < err_T(t);
                Param_T(t,:) = [c(i),f(j),e(k),err_temp];
         
                err_T(t) = err_temp;
            end
        end
     end
end

end



c_T = Param_T(:,1).';
f_T = Param_T(:,2).';
e_T = Param_T(:,3).';

%Q3, Plot
figure(1)
d_plot = linspace(1,48, 48);
for t = 1:length(T)
     h_plot(:, t) = (c_T(t).* d_plot)./((d_plot.^e_T(t))+f_T(t));
end
 
plot(D, H_Gum(1,:),'mo',D, H_Gum(2,:), 'ko',D, H_Gum(3, :), 'go', d_plot, h_plot(:,1),'m-',d_plot, h_plot(:,2), 'k-',d_plot, h_plot(:,3), 'g-');
title('DDF curves and Gumbel distribution');

legend({'Gumbel: T = 10 years', 'Gumbel: T = 40 years', 'Gumbel: T = 100 years', ...
    'DDF: T = 10 years', 'DDF: T = 40 years', 'DDF: T = 100 years'},'Location','SouthEast') 
xlabel('Duration [hours]');
ylabel('Rainfall depth [mm]');
saveas(gcf,'4.png')

% Question 4: plot to estimate return period for a event with 80 mm of rainfall depth and a duration of 16 hours
figure(2)
d_plot = linspace(1,48, 48);
for t = 1:length(T)
     h_plot(:, t) = (c_T(t).* d_plot)./((d_plot.^e_T(t))+f_T(t));
end
 
plot(D, H_Gum(1,:),'m.',D, H_Gum(2,:), 'k.',D, H_Gum(3, :), 'g.', d_plot, h_plot(:,1),'m-',d_plot, h_plot(:,2), 'k-',d_plot, h_plot(:,3), 'g-');
hold("on")
scatter(16,80,120,'blue','*')
title('DDF curves and Gumbel distribution');

legend({'Gumbel: T = 10 years', 'Gumbel: T = 40 years', 'Gumbel: T = 100 years', ...
    'DDF: T = 10 years', 'DDF: T = 40 years', 'DDF: T = 100 years', 'critical rainfall event of 16h'},'Location','SouthEast') 
xlabel('Duration [hours]');
ylabel('Rainfall depth [mm]');
saveas(gcf,'Q4.png')