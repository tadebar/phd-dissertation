%% ANALYZEINSERTANDTURN
% This script reads the edited needle segmentation point data previously
% saved into matlab .mat files, and fits circular curves to each insertion
% path.
%
% The articulated-tip needle is compared to the bent-tip needle in ability
% to steer after inserting straight
%
%
% Troy Adebar
% Stanford University
% 2015-1-25

%% Initialize
close all; clear all; clc;
base = 'F:\Dropbox\Troy Adebar Research Folder\1 - Active Needles\Comparison Experiments\data\insert and turns';
% FOR ORIGINAL ARRANGEMENT USING 2 OF EACH
% folders = {'old_3','new_3','old_4','new_4',};
% postfix = {'a','b'};
% angle_corrections = {0,-7,0,-5};
% flip = {-1,1,-1,1};
% x_corrections = {0,-10,-2,0};
folders = {'old_4','new_4',};
postfix = {'a','b'};
angle_corrections = {0,-5};
flip = {-1,1};
x_corrections = {-2,0};


col = 'rb';
N = length(folders);

% Create the first figure
hfig = figure(1); clf;
% Resize the plot (assuming T-420 screen)
set(hfig,'units','normalized','position',[0.1 0.1 .25 .4])
figure(1); clf;

% Loop thru folders
for j = 2
    hold on;
    for i = 1:2
        % Load presaved points
        folder = [folders{j} postfix{i}];
        file = 'scan_e';
        fname = fullfile(base,folder,file);
        load(fname);
        
        % Subtract first position for common origin
        if i == 1
            o = gpoints(1,:) + [x_corrections{j} 0 0 0 0];
        end
        gpoints = gpoints - repmat(o,length(gpoints),1);
        
        % Rotate points about z for better alignment in figure
        ang = angle_corrections{j};
        rot = [cosd(ang) -sind(ang) 0; 
               sind(ang) cosd(ang)  0;
               0            0       1;];
        for k = 1:length(gpoints)
            gpoints(k,1:3) = ( rot*gpoints(k,1:3)' )';
        end
        
        % Correct flips
        gpoints(:,2) = gpoints(:,2).*flip{j};
        gpoints(:,1) = gpoints(:,1).*-1;
        
        % Scatter the segmented needle points
        plot3(gpoints(:,2).*-1, gpoints(:,1), gpoints(:,3),[col(i) 'x'],...
            'MarkerSize',7);
        axis([-20 40 0 100 -50 50]);
        daspect([1 1 1]);
        
        % Save the points
        allPoints{j,i} = gpoints;
        
    end
end
        
for j = 2
    hold on;
    for i = 1:2
        gpoints = allPoints{j,i};
        % Fit straight line to the points
        if i == 1
            x = gpoints(:,1);
            py = polyfit(x, gpoints(:,2), 1);
            pz = polyfit(x, gpoints(:,3), 1);
            lpoints = [x polyval(py,x) polyval(pz,x)];
            plot3(lpoints(:,2).*-1,lpoints(:,1),lpoints(:,3),'r','LineWidth',2);
            pjoint = gpoints(end,1:3);
            xjoint = x(end);
        else
        % Fit a curve to the second points
        [ r,c,circ_pts ] = findcurvature(gpoints(:,1:3),100);
        plot3(circ_pts(:,2).*-1,circ_pts(:,1),circ_pts(:,3),'b','LineWidth',2);
        
        % Show relaxation distance
        plend = lpoints(end,1:3);
        pend = plend + [0 -10 0];
        plot3([plend(2) pend(2)].*-1,[plend(1) pend(1)],[plend(3) pend(3)],'k--','LineWidth',2);
        delta = norm(plend-pend);
        str = sprintf('%.1f mm',10.29);
        th = text(-15,50,str);
        set(th,'BackgroundColor','w')
        
        end
        
    end
    % Format the subplot
    box on; grid on;
    xlabel('\itx\rm-direction (mm)');
    ylabel('\ity\rm-direction (mm)');
    
%     if j == 1
%         str = sprintf('Bent-Tip Needle (%s = %.0f mm)','\itl\rm',4);
%         title(str);
%     end
%     if j == 2
%         str = sprintf('Articulated-Tip Needle (%s = %.0f mm)','\itl\rm',9);
%         title(str);
%     end
    
    legend('initial','final','location','NorthWest');
    
%     % Label the average curvature
%     str = sprintf('%s = %.1f mm','\it\rho\rm_{avg}',rho_bar(j));
%     tx = text(-85,86,0,str);
%     set(tx,'BackgroundColor','w')
%     % Title with the tip angle
%     str = sprintf('%s = %.0f deg','\it\alpha\rm',alpha(j));
%     title(str);
    
end

% Format the first plot overall
set(gcf, 'color', 'w');
set(findall(gcf,'-property','FontSize'),'FontSize',18,...
    'fontName','Times New Roman')
% Export to pdf
export_fig('InsertAndTurn.pdf');

