%% GenerateUKFAccuracyPlot
% Creates a plot of UKF accuracy results
% -------------------------------------------------------------------------
%% Load results
clear all; close all; clc;
load('UKFAccuracyResults.mat');
GPSfilt = xfit;
x_hat = xest;


%% Plot actual, measured, and Kalman filtered position, along with commands
    figure(1);
    clf;
    tits = {'p_1','p_2','p_3','\theta','l','\rho'};
    cmds = {'rotation (deg.)','insertion (mm)','radius of cuvature (mm)'};
    % Plot position of tip
    for o = 1:3
        subplot(2,3,o);
        hold on;
%         % Plot the raw GPS state
%         plot(squeeze(GPSraw(o,4,:)),'k.','LineWidth',1,'MarkerSize',1);
        % Plot the filtered GPS state
        plot(squeeze(GPSfilt(o,4,:)),'k-','LineWidth',2);
        % Plot the Kalman filtered state
        plot(squeeze(x_hat(o,4,:)),'r--','LineWidth',2);
        % Plot the raw measurements
        plot(squeeze(z(o,4,:)),'bo','LineWidth',1);
%         % Plot the target
%         plot(squeeze(t(o,1,:)),'k--','LineWidth',0.5);
        % Format the plot
        xlim([0 1100]);
        if o == 3
            legend('GPS','UKF','Meas.','Target','Location','NorthWest');
        end
        grid on; 
        title(tits{o},'FontAngle','italic');
        ylabel('position (mm)');
        hold off;
    end
    % Plot control inputs
    u([2 3],:,:) = u([3 2],:,:);
    for o = 4:6
        subplot(2,3,o);
        hold on;
        % Plot the command value
        if o == 4
        plot(cumsum(squeeze(u(o-3,:,:))).*180/pi,'k-','LineWidth',2);
        end
        if o == 5
        plot(cumsum(squeeze(u(o-3,:,:))),'k-','LineWidth',2);
        end
        if o == 6
        plot(squeeze(u(o-3,:,:)),'k-','LineWidth',2);
        end
        ylabel(cmds(o-3));
        % Format the plot
        grid on;
        xlabel('k');
        title(tits{o},'FontAngle','italic');
        hold off;
        xlim([0 1100]);
    end
    set(gcf,'color','w');    
    set(findall(gcf,'-property','FontSize'),'FontSize',20,...
        'fontName','Times New Roman')
    set(gcf,'units','normalized','position',[0 0 1 .8]);
    export_fig('UKFAccuracy.pdf');
  