%KALPLOTS Plots results of singleKalmanSimulation for paper figure
% simulationPlots(act,kal,grd,x,x_hat,z,u,K)
% Required workspace variables:
%           p:   simulation target point
%           x:   simulated state vector over time
%           x_hat: estimated state vector over time
%           z: simulated measurements
%           u: simulated command inputs
%           K: simulated Kalman filter gains
%
% author:   Troy Adebar
% date:     1/26/2014

%% Plot actual, measured, and Kalman filtered position, along with commands
clear all; clc;
load('singleUKFSimResults');
% Determine number of time steps
N = length(x);
t = 1:N;

hfig = figure(1); clf;
% Resize the plot
set(hfig,'units','normalized','position',[0 0 .4 1])

% Plot p_0
subplot(4,1,1);
hold on;
% Plot the actual simulation state
plot(t,squeeze(x(1,:,:)),'k-','LineWidth',2);
% Plot the Kalman filtered state
plot(t,squeeze(x_hat(1,:,:)),'r--','LineWidth',2);
% Plot the raw measurements
plot(t,squeeze(z(1,:,:)),'bo','LineWidth',2,'MarkerSize',8);
% Plot the target
plot(t,15.*ones(size(t)),'--','color',[.5 .5 .5],'LineWidth',2);
% Format the plot
legend('Actual','UKF','Measured','Target','Location','NorthWest');
box on; 
ylabel('$p_0$ (deg.)',...
    'Interpreter','latex'); xlim([0 N]); ylim([-5 20]);
hold off;
% grid on; 
% ax = gca;
% ax.GridLineStyle = ':';

% Plot r_0
hs = subplot(4,1,2);
hold on;
% Plot the actual simulation state
plot(t,squeeze(x(4,:,:)).*180/pi,'k-','LineWidth',2);
% Plot the Kalman filtered state
plot(t,squeeze(x_hat(4,:,:)).*180/pi,'r--','LineWidth',2);
% Plot the raw measurements
plot(t,squeeze(z(4,:,:)).*180/pi,'bo','LineWidth',2,'MarkerSize',8);
% Format the plot
% legend('Actual','Estimate','Measured','Location','SouthWest');
box on; 
ylabel('$r_0$ (deg.)',...
    'Interpreter','latex');
xlim([0 N]); ylim([-180 180]);
set(hs,'Ytick',[-180 -90 0 90 180])
hold off;
% grid on; 
% ax = gca;
% ax.GridLineStyle = ':';

% Plot the first two control inputs
subplot(4,1,3);
t_short = t(1:end-1);
% Plot delta theta and ro
d_th = squeeze(u(1,:,:)).*180/pi;
ro = squeeze(u(2,:,:));
[ax,h1,h2] = plotyy(t_short,d_th,t_short,ro,'plot');
% Format the right axis (rho)
axes(ax(1));
ylabel('$\delta\theta$ (deg.)',...
    'Interpreter','latex');
set(ax(1),'ycolor','k') 
xlim([0 N]);
set(h1,'LineWidth',2,'color','k');
% grid on;
box on;
% Format the left axis (delta theta)
axes(ax(2));
ylabel('$\rho_{\mathrm{des}}$ (mm)',...
        'Interpreter','latex');
xlim([0 N]); 
set(ax(2),'ycolor','k') 
set(h2,'LineWidth',2,'color','k','LineStyle','--');
% Format the plot
leg = legend('\rho_{des}','\delta\theta',...
    'Location','NorthWest',...
    'Interpreter','latex');
set(leg,'color','w')
hold off;
% grid on;
box on;
% ax = gca;
% ax.GridLineStyle = ':';

% Plot the Kalman filter gains
subplot(4,1,4);
hold on;
% Plot the p_0 Kalman gain
plot(t,squeeze(K(1,1,:)),'k-','LineWidth',2);
% Plot the r_0 Kalman gain
plot(t,squeeze(K(4,4,:)),'k--','LineWidth',2);
% Format the plot
legend('\itK_{11}','\itK_{44}','Location','NorthEast');
box on; ylabel('UKF gain');
xlim([0 N]);
hold off;
% grid on; 
% ax = gca;
% ax.GridLineStyle = ':';

%% Format the overall plot
xlabel('insertion step')
set(gcf, 'color', 'w');
set(findall(gcf,'-property','FontSize'),'FontSize',16,...
    'fontName','Times New Roman')


%% Export to pdf
figure(1);
export_fig('SimulationResults.pdf');


