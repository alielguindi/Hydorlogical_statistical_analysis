1% -------------------------------------------------------------------------
% Course: Hydrology for Engineers
% Assignment 1
% Part 2: Fit a Gumbel distribution and calculate critical rainfall depths
% -------------------------------------------------------------------------

clear variables %clear the workspace variables
close all %close alla figures
clc %clear the command window

% -------------------------------------------------------------------------
% # 1: Compute the Weibull plotting position
% -------------------------------------------------------------------------

% import the data from Part1 using the function load
load assignment1_output_part1.mat





[rownum,colnum]=size(AnnualMax);

% Firstly we sort the matrix
for i = 1:1:colnum;
    AnnualMaxSort(: , i) = sort(AnnualMax(: , i));
    
end

% reduced variable computation
for i = 1:1:rownum;  
    Fh(i) = i / (rownum + 1); % empirical frequency computation
    yF(i) = -log(-log(Fh(i)));    % reduced variable computation
end


% -------------------------------------------------------------------------
% # 2: Fit the Gumbel distribution:
% -------------------------------------------------------------------------


sigma_y = std(yF,0);
mean_y = mean(yF);


for i = 1:1:colnum; % iteration on different durations
    
    % estimating parameters for moments method   
    mean_h(i) =  mean(AnnualMaxSort(:, i)); 
    sigma_h(i) =  std(AnnualMaxSort(:, i),0);
    alpha_h(i) = pi / (sigma_h(i)* sqrt(6)); 
    u_h(i) = mean_h(i) - (0.577/ alpha_h(i));
    
    
    
    % estimating parameters for Gumbel method
    alpha_y(i) = sigma_y/ sigma_h(i);
    u_y(i) = mean_h(i) -((mean_y / sigma_y) * sigma_h(i));
    
end


% -------------------------------------------------------------------------
% # 3:  Compute analytical Gumbel distributions:
% -------------------------------------------------------------------------



%colours for plotting

colors= [0 0.4470 0.7410;  %blue
        0.8500, 0.3250, 0.0980; %orange
        0.9290, 0.6940, 0.1250; %jaune
        0.75, 0, 0.75; %violet
        0, 0.5, 0; %vert
        1, 0, 0]; %rouge

for i = 1:1:colnum;

     
    % Matrix with more values 
    %AnnualMaxSort_1(: , i) = linspace(min(AnnualMaxSort(:,i)),max(AnnualMaxSort(:,i)), 500 );
    AnnualMaxSort_1(: , i) = linspace(0,120, 1000 );
    % new rownum and colnum (rownum_1, colnum_1)
    [rownum_1,colnum_1]=size(AnnualMaxSort_1);
   
    for h = 1:1:rownum_1;
        % Gumbel distribution
        P(h,i) = exp(-exp(-alpha_y(i)*(AnnualMaxSort_1(h,i) - u_y(i))));
        
        % Fh with more values 
        Fh_1(h) = h / (rownum_1 + 1);

    end
    
     
% -------------------------------------------------------------------------
% # 4:   Plot: plot the fitted Gumbel distribution:
% -------------------------------------------------------------------------
    
    figure(1)
    plot(AnnualMaxSort_1(:, i),P(:,i ), 'Color',colors(i,:));
    hold('on')
    ylim([0 1.1])
    plot(AnnualMaxSort(:, i),Fh,'.', 'Color',colors(i,:));
    grid on;
    title('Gumbel distribution and empirical frequency for each duration');
    xlabel('Maximal annual precipitation [mm]');
    ylabel('Empirical frequnecy/Gumbel distribution [-]');
   
    legend({'Gumbel distribution D=1h','Empirical frequency D=1h','Gumbell distribution D=3h','Empirical frequency D=3h',...
    'Gumbel distribution D=6h','Empirical frequency D=6h','Gumbel distribution D=12h','Empirical frequency D=12h',...
    'Gumbell distribution D=24h',' Empirical frequency D=24h','Gumbel distribution D=48h','Empirical frequency D=48h'},'Location','bestoutside')
    saveas(gcf,'2.png');
%     

 end


% -------------------------------------------------------------------------
% # 5:   Th and h:
% -------------------------------------------------------------------------



%return period:  
for i = 1:1:length(Fh);
    Th(i) = 1 /(1-Fh(i));

end

%new Th with more values (Th_plot)
for i = 1:1:length(Fh_1);
    Th_plot(i) = 1 /(1-Fh_1(i));

end

% h(T)
for i = 1:1:colnum;
    for h = 1:1:rownum_1;     
        H_1(h,i) = u_y(i) - (1/alpha_y(i))*log(-log(1-1/Th_plot(h)));
    end
end


% -------------------------------------------------------------------------
% # 6: Plot rainfall depth obtained through the Gumbel distribution and 
% measured rainfall depths against the empirical return periods against
% the return period, for each rainfall duration
% -------------------------------------------------------------------------


for i = 1:1:colnum % iteration on each duration
    figure(2)
    plot(Th_plot, H_1(:, i),'Color',colors(i,:) ,'DisplayName','rainfall depth calculated');
    xlim([0 60])
    ylim([0 160])
    hold('on')
  
    plot(Th, AnnualMaxSort(:, i), '.', 'Color',colors(i,:),'DisplayName','rainfall depth measured');
    grid on
    title('return period vs rainfall depth for each duration')
    xlabel('return period')
    ylabel('rainfall depth [mm]')
    legend({'Gumbel distribution D=1h','Empirical frequency D=1h','Gumbell distribution D=3h','Empirical frequency D=3h',...
    'Gumbel distribution D=6h','Empirical frequency D=6h','Gumbel distribution D=12h','Empirical frequency D=12h',...
    'Gumbell distribution D=24h',' Empirical frequency D=24h','Gumbel distribution D=48h','Empirical frequency D=48h'},'Location','bestoutside')
    saveas(gcf,'3.png');

    figure(4)
    plot(Th_plot, H_1(:, i),'Color',colors(i,:) ,'DisplayName','rainfall depth calculated');
    xlim([0.5 6])
    ylim([0 100])
    hold('on')
  
    plot(Th, AnnualMaxSort(:, i), '.', 'Color',colors(i,:),'DisplayName','rainfall depth measured');
    grid on
    title('return period vs rainfall depth for each duration')
    xlabel('return period')
    ylabel('rainfall depth [mm]')
    legend({'Gumbel distribution D=1h','Empirical frequency D=1h','Gumbell distribution D=3h','Empirical frequency D=3h',...
    'Gumbel distribution D=6h','Empirical frequency D=6h','Gumbel distribution D=12h','Empirical frequency D=12h',...
    'Gumbell distribution D=24h',' Empirical frequency D=24h','Gumbel distribution D=48h','Empirical frequency D=48h'},'Location','bestoutside')
    saveas(gcf,'3zoom.png');



end 


% -------------------------------------------------------------------------
% # 7: Include a table: Create a matrix H_Gum
% -------------------------------------------------------------------------


Th_3 = [10,40,100];

for i=1:1:length(Th_3) 
     for k=1:1:length(D)
         H_Gum(i,k)= u_y(k) - (1/alpha_y(k))*log(-log(1-1/Th_3(i)));
     end
end


% -------------------------------------------------------------------------
% # 8: Save data
% -------------------------------------------------------------------------

T = Th_3;

save('assignment1_output_part2.mat','D','T','H_Gum');


% Question 3
% h(100)
for i = 1:1:colnum;
     H_1(h,i) = u_y(i) - (1/alpha_y(i))*log(-log(1-1/Th_plot(h)));
end

% Additional Questions report 3
% h(100)
for i = 1:1:colnum;
     H_alpha(1,i) = u_y(i) - (1/alpha_y(i))*log(-log(1-1/100));
     H_alpha(2,i) = u_y(i) - (1/((90/100)*alpha_y(i)))*log(-log(1-1/100));
     H_alpha(3,i) = u_y(i) - (1/((110/100)*alpha_y(i)))*log(-log(1-1/100));
end



