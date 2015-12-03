%REACHABLESIZEBYRHO Creates a figure that shows how the size of the
%reachable set changes as a function of radius of curvature rho

%% Initialize
clear all; clc

%% Load the results from .mat files
% load the right-liver intercostal approach
load v1;
data1 = data;
% load the left-liver costal arch approach
load v2;
data2 = data;

%% Define the radius vectors to analyze
rho = 10:0.1:200;


%% Analyze the v1 data
Nliver{1} = numel(find(data1.fineVol.V>=0));
for i = 1:numel(rho)
   N(i) = numel(find(data1.fineVol.R>=rho(i)));    
end
Naccessible{1} = N;
Paccessible{1} = Naccessible{1}./Nliver{1};


%% Analyze the v2 data
Nliver{2} = numel(find(data2.fineVol.V>=0));
for i = 1:numel(rho)
   N(i) = numel(find(data2.fineVol.R>=rho(i)));    
end
Naccessible{2} = N;
Paccessible{2} = Naccessible{2}./Nliver{2};


%% Analyze the combined data
Nliver{3} = numel(find(data2.fineVol.V>=0));
for i = 1:numel(rho)
   N(i) = numel(find(data1.fineVol.R>=rho(i) | data2.fineVol.R>=rho(i)));    
end
Naccessible{3} = N;
Paccessible{3} = Naccessible{3}./Nliver{3};


%% Plot the results

figure(1); clf; hold on;
plot(rho,Paccessible{1},'k-','LineWidth',3);
plot(rho,Paccessible{2},'k--','LineWidth',3);
plot(rho,Paccessible{3},'-.','LineWidth',3,'color',[.7 .7 .7]);

xlabel('\it\rho\rm');
ylabel('$|R^{(i)}|/|L|$',...
        'Interpreter','latex');

set(gca,'XLim',[10 200]);
set(gca,'XTick',20:20:180);
set(gca, 'xdir','reverse');

grid on;
box on
set(gcf,'color','w');

% Resize the plot (assuming ASUS screen)
set(gcf,'units','normalized','position',[0 0 .5 .5])

legend({'${R}^{(1)}$',...
        '${R}^{(2)}$'...
        '${R}^{(1)}\cup{R}^{(2)}$'},...
        'Location','NorthWest',...
        'Interpreter','latex');
    


set(findall(gcf,'-property','FontSize'),'FontSize',25,...
    'fontName','Times New Roman')


% Save the results figure
export_fig('ReachableSizeByRho.pdf');
