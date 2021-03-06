function [  ] = kalmanPlots(act,kal,grd,p,x,x_hat,z,u,K)
%KALPLOTS Plots results of KalmanSimulation
% simulationPlots(act,kal,grd,x,x_hat,z,u,K)
% Inputs:   act: boolean that controls 3D plotting of simulation
%           kal: boolean that controls 3D plotting of estimation
%           p:   simulation target point
%           x:   simulated state vector over time
%           x_hat: estimated state vector over time
%           z: simulated measurements
%           u: simulated command inputs
%           K: simulated Kalman filter gains
%
% author:   Troy Adebar
% date:     11/19/2013

%% Plot actual needle pose generated by simulation
if( act )
    % Format the plot
    hfig = figure(1); clf; format3Dplot;
    title('Needle Steering Simulation - Actual State');
    % Highlight the entry position and target
    hold on;
    plot3(x(1,:,1),x(3,:,1),x(2,:,1),'ko','MarkerSize',10,...
        'MarkerFaceColor','k');
    plot3(p(1),p(3),p(2),'k^','MarkerSize',10,'MarkerFaceColor','k');
    hold off;
    % Plot the state vectors
    for t = 1:size(x,3)
        plotstate(x(:,1,t),hfig,2);
    end
end
%% Plot needle pose as estimated by either Kalman filter or sensors
if( kal )
    % Format the plot
    hfig = figure(2); clf; format3Dplot;
    title('Needle Steering Simulation - Estimated State');
    % Highlight the entry position and target
    hold on;
    plot3(x_hat(1,:,1),x_hat(3,:,1),x_hat(2,:,1),'ko','MarkerSize',10,...
        'MarkerFaceColor','k');
    plot3(p(1),p(3),p(2),'k^','MarkerSize',10,'MarkerFaceColor','k');
    hold off;
    % Plot the state vectors
    for t = 1:size(x_hat,3)
        plotstate(x_hat(:,1,t),hfig,2);
        % plotarc(c(:,1,t),x_est(1:3,1,t),p,hfig);
    end
end
%% Plot actual, measured, and Kalman filtered position, along with commands
if( grd )
    hfig = figure(3);
    clf;
    tits = {'p1','p2','p3','r1','r2','r3',...
        '\delta\theta','u','l','t1','t2','t3'};
    cmds = {'rad','mm','mm'};
    % Plot position and orientation of tip
    for o = 1:6
        subplot(4,3,o);
        hold on;
        % Plot the actual simulation state
        plot(squeeze(x(o,:,:)),'k-','LineWidth',2);
        % Plot the Kalman filtered state
        plot(squeeze(x_hat(o,:,:)),'r--','LineWidth',2);
        % Plot the raw measurements
        plot(squeeze(z(o,:,:)),'bo','LineWidth',1);
        % Format the plot
        legend('Actual','Estimate','Measured','Location','SouthEast');
        grid on; xlabel('t'); title(tits{o});
        if( o <= 3 )
            ylabel('position (mm)');
        else
            ylabel('rotation vect.');
        end
        hold off;
    end
    % Plot input commands
    for o = 7:9
        subplot(4,3,o);
        hold on;
        % Plot the command value
        plot(squeeze(u(o-6,:,:)),'k-','LineWidth',5);
        ylabel(cmds(o-6));
        % Format the plot
        grid on;
        xlabel('t');
        title(tits{o});
        hold off;
    end
    % Plot Kalman gains
    subplot(4,3,11);
    col = 'rgbcmk';
    for s = 1:6
        hold on;
        plot(1:size(K,3),squeeze(K(s,s,:)),col(s),'LineWidth',5);
        hold off;
    end
    title('K');
    xlabel('t');
    grid on;
    set(gcf,'Color',[1 1 1]);
end

end

function format3Dplot
% Format the 3D plots of simulation and estimate results
axis equal;
grid on;
xlabel('x-axis (mm)'); ylabel('z-axis'); zlabel('y-axis');
set(gca,'ZDir','reverse');
view(-180,90);
set(gcf,'Color',[1 1 1]);
end


