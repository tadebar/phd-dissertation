% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Troy Adebar
% Stanford University
% October 2, 2015
%
% This script generates a plot of closed-loop freehand-US-guided needle
% steering
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Initialize
clc; clear all; close all;
load ClosedLoopBenchtopData;
utilpath = 'F:\ultrasteer\src\MATLAB_UnscentedKalmanFilter\Matlab Model\Utility Functions';
addpath(utilpath);

%% Define constansts
vws = [1 500 1000 1500 2750];
Nvw = length(vws);
col = 'rgb';


%% Plot 3D path of estimator
hfig = figure(1); clf;
for i = 1:Nvw
    k = vws(i);
    subplot(1,Nvw,i); hold on;
    % Target
    plot( t(2,:,k), t(3,:,k), 'k^', 'MarkerSize',10,'LineWidth',2);
    % Current state
    p = xest(1:3,4,k);
    % Loop through x,y,z axes
    for j = 1:3
        v = [p p+20*xest(1:3,j,k)];
        plot(v(2,:),v(3,:),col(j),'LineWidth',2);
    end
    plot(p(2),p(3),'ko','MarkerSize',5);
    % Position history
    plot(squeeze(xest(2,4,1:k)), squeeze(xest(3,4,1:k)),'k--','LineWidth',2);
    % Measurement history
    plot(squeeze(z(2,4,1:k)), squeeze(z(3,4,1:k)),'bo','MarkerSize',3,'LineWidth',2);
    
    % format
    grid on; box on; axis equal; axis([0 80 120 300]);
    xlabel('y (mm)');
    if i == 1
        ylabel('z (mm)');
    else
        set(gca,'YTickLabel',[]);
    end
    set(gcf,'color','w');
    set(findall(gcf,'-property','FontSize'),'FontSize',20,...
        'fontName','Times New Roman')
    set(gcf,'units','normalized','position',[0 0 1 .8]);
end

%% Export the figure
export_fig('ClosedLoopBenchTop.pdf');