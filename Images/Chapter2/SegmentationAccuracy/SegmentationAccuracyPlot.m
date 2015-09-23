% -------------------------------------------------------------------------
% Author: Troy Adebar date: 2012-06-03
% Title: SegmentationAccuracyPlot
%
% Summary: This mfile analyzes the results from the segmentation data, and
% creates a boxplot.
% 
% NOTE: The results are based on matlab polynomial fit to the segmentation
% points.
% -------------------------------------------------------------------------
% Initialize
clear all; close all; clc;
% Create cell array of category labels
cats ={'Configuration','Lateral Position','Needle Diameter','Vibration Frequency'};
% Create cell matrix of value labels
all_vals = {'Straight','Curved',[];
           'Center','Lateral',[];
           '0.38 mm','0.48 mm','0.58 mm';
           '400 Hz','600 Hz','800 Hz'};
% Load precomputed error values
load('F:\Dropbox (Stanford CHARM Lab)\Troy Adebar Research Folder\1 - TBME Experiments\Segmentation Accuracy\Error');

% Switch value label numbers for the configuration test to straight first
i_curved = find(error(:,4) == 1 & error(:,5) == 1);
i_straight = find(error(:,4) == 1 & error(:,5) == 2);
error(i_curved,5) = 2;
error(i_straight,5) = 1;

% Define total number of datapoints
N = size(error,1);
% Define array that will hold number of points for each value and category
count = zeros(4,3);
for i = 1:N
    val_labels(i,1) =  all_vals(error(i,4),error(i,5));
    count(error(i,4),error(i,5)) = count(error(i,4),error(i,5)) + 1;
end

% Create figure 
hFig = figure(5);
h1 = boxplot(error(:,1),{error(:,4) error(:,5)},'labels',{cats(error(:,4))' val_labels},...
    'notch','on','factorseparator',[1],'labelverbosity','minor');
% Turn off outliers
set(h1(7,:),'Visible','off');
% Increase line weights
set(h1,{'linew'},{2});
% Change font
fontsize = 18;
set(gca, 'FontSize', fontsize,'FontName','Times New Roman');
h = findobj(gca,'Type','text');
set(h,'FontSize',fontsize,'FontName','Times New Roman')
% Format y-axis
ylabel('Localization Error (mm)');
maxY = 3.4;
ylim([0 maxY])
set(gca,'YTick',0:1:maxY)
% Change background color
set(gcf,'Color','w')
% Set size
set(hFig,'units','normalized','outerposition',[0 0.2 1 0.45]);
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') - [0 5 0])
% Add text indicating the number of samples for each error condition
ind = [1 5 2 6 3 7 11 4 8 12];
for i = 1:10
    th = text(i-0.3,2.95, ['K = ' num2str(count(ind(i)))]);
    set(th,'FontSize',fontsize,'FontName',...
        'Times New Roman','BackgroundColor','w')
end
% Save as PDF
export_fig(['SegmentationAccuracy.pdf'])

