%% Generate a figure with experimental results from UKF steering trial

% Initialize
clear all; clc;
N = 12;
i1 = 7;
i2 = 12;
hfig = figure(1); clf;
dir = 'data\11\';

for i = [1:N]
    % Read the files
    raw = readFiles(dir, i );
    % Reformat vectors with known size
    a(:,:,i) = reshape(raw.a,4,1);
    b(:,:,i) = reshape(raw.b,4,1);
    x(:,:,i) = reshape(raw.x,6,1);
    z(:,:,i) = reshape(raw.z,6,1);
    u(:,:,i) = reshape(raw.u,3,1);
    t(:,:,i) = reshape(raw.t,3,1);
    % Reformat raw scan converted points
    rawSC = raw.scpts;
    n_SC = size(rawSC(1:end-1),2)/3;
    scpts{i} = (reshape(rawSC(1:end-1),3,n_SC))';
end

%% Make a single plot to visualize
figure(1); clf; hold on;
% Resize the plot
set(hfig,'units','normalized','position',[0 0 .3 1])
% Plot the each UKF-filtered state measurement
i = i1;
% Tip frame:
plotstate(x(:,:,i),3);
th = text(-12,x(3,:,i)+4,x(2,:,i),'{\bf\itx} = [-2.28 52.00 -0.76 -12.74 -18.66 48.40]^T');
set(th,'BackgroundColor','w')
% Tip frame measurement:
plotstate(z(:,:,i),1.5);
th = text(-12,z(3,:,i)-3,z(2,:,i),'{\bf\itz} = [-1.46 54.12 -2.07 -64.62 -9.38 4.55]^T');
set(th,'BackgroundColor','w')
% Segmented needle curve:
t_scpts = scpts{i};
z_seg = t_scpts(1,3):0.1:t_scpts(end,3);
x_seg = polyval(a(:,:,i),z_seg);
y_seg = polyval(b(:,:,i),z_seg);
plot3(x_seg,z_seg,y_seg,'color',[.5 .5 .5],'LineWidth',3)

% Target:
plot3(t(1,1,i),t(3,1,i),t(2,1,i),'k^','MarkerSize',15,'LineWidth',3,'MarkerFaceColor',[1 1 1]);
th = text(t(1,:,i)+2,t(3,:,i)+0.5,t(2,:,i),'{\bf\itt} = [-10, 50, 10]^T');
set(th,'BackgroundColor','w')
% Plot the final curve:
i = i2;
t_scpts = scpts{i};
% z_seg = t_scpts(1,3):0.5:t_scpts(end,3);
z_seg = 0:0.5:t_scpts(end,3);
x_seg = polyval(a(:,:,i),z_seg);
y_seg = polyval(b(:,:,i),z_seg);
% plot3(x_seg,z_seg,y_seg,'.','color',[.5 .5 .5],'LineWidth',3)

% Format the plot
axis equal;
grid on; box on;
xlabel('3DUS lateral position (mm)');
zlabel('3DUS axial position (mm)');
ylabel('3DUS elevational position (mm)')
xlim([-15 10])
ylim([-7 12])
zlim([-10 15])
set(gca,'XTick',[-10:5:5],'YTick',[-5:5:10]);
set(gcf, 'color', 'w');
set(findall(gcf,'-property','FontSize'),'FontSize',12,...
    'fontName','Times New Roman')
hold off;

%% Export to pdf
export_fig('ExperimentalResults.pdf');

