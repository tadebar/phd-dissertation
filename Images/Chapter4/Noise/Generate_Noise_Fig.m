% Troy Adebar
% Stanford University
% 12/16/2013
%
% This script reads saved process and measurement noise vectors and
% generates a plot of relative frequencies
%--------------------------------------------------------------------------
%% Initialize
clc; clear all;

% Load the data
load('MeasurementNoise');
Wm = W;
Wm(4:end,:) = Wm(4:end,:).*180/pi;
load('ProcessNoise');
Wp = [W -W];
Wp(4:end,:) = Wp(4:end,:).*180/pi;
% Combine in a cell array
W = {Wm,Wp};

%% Plot histograms
hfig = figure(1); clf;
set(hfig,'units','normalized','position',[0 0 .3 .3])
a = 4.5;
b = 4.5;
% indices for accesing noise data
cell = [1 2 1 2]; 
% indices for accessing specific state variable
state = [1 1 4 4];
% axis labels for plots
xlabels = {'{\itp_0} (mm)','{\itp_0} (mm)','{\itr_0} (deg.)','{\itr_0} (deg.)'};
ylabels = {'relative freq.',[],'relative freq.',[]};
% axis limits for plots
xlims = {[-4 4],[-2 2],[-180 180],[-3 3]};
ylims = {[0 1],[0 1],[0 0.02],[0 1]};
% titles for plots
tits = {'Measurement Noise','Process Noise',[],[]};
% units for sigma
units = {' mm',' mm',' deg.',' deg.'};
for i = 1:4
    % Histogram point data
    lim = xlims{i};
    % Number of bins for histogram
    bins = 30;
    % Centers of histogram
    locations = linspace(lim(1),lim(2),bins);
    % Separate the current vector of data
    Wt = W{cell(i)};
    Wi = Wt(state(i),:);
    % Characterize the data
    n = length(Wi);
    q = std(Wi,1,2);
    % Modify histogram to be relative frequency
    heights = histc(Wi,locations);
    width = locations(2)-locations(1);
    heights = heights / (n*width);
    % Put the histogram on a bar graph
    subplot(2,2,i);
    bar(locations,heights,'hist');
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',.7*[1 1 1] ,'EdgeColor',.5*[1 1 1],'LineWidth',2)
    % Add the normal distribution with the corresponding sigma
    norm_x = linspace(lim(1),lim(2));
    norm_y = normpdf(norm_x,0,q);
    hold on; 
    line(norm_x,norm_y,'color',.3*[1 1 1],'LineWidth',3,'LineStyle','--');
    hold off;
    % Add text to describe the sigma of the distribution
    sigstr = sprintf('%.2f',q);
    str = ['{\it\sigma} = ' sigstr];
    text(0.6,0.75,str,'color','k','Units','normalized');
    % Format the plot
    xlabel(xlabels{i});
    ylabel(ylabels{i});
    xlim(xlims{i});
    ylim(ylims{i});
    ht = title(tits{i});
    set(findall(gcf,'-property','FontSize'),'FontSize',12,...
        'fontName','Times New Roman')
    set(gca,'TickLength', [.04 .04]);
end
set(gcf,'Color','w')
%% Export the figure to pdf
export_fig('Noise.pdf')



