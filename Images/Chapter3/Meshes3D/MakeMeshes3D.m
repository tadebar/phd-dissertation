%MAKEMESHES3D Create figure to show meshes 

%% Initialize
clear all; clc;


%% Import STL meshes, returning PATCH-compatible face-vertex structures
fv = stlread('stl/liver.stl');
data.mesh.lv = fv;

ptl = stlread('stl/portalveins.stl');
data.mesh.obs(1) = ptl;

hep = stlread('stl/hepaticveins.stl');
data.mesh.obs(2) = hep;


%% Define the entry locations
entry(1).p1            = [150 35 -20]';           % introducer point
entry(1).v             = [-1 0 0]';              % introducer vector 

entry(2).p1            = [0 90 50]';           % introducer point
entry(2).v             = [1 -1 0]'./sqrt(2);    % introducer vector 

l = 50;

entry(1).p2            = entry(1).p1 - l.*entry(1).v;
entry(2).p2            = entry(2).p1 - l.*entry(2).v;
    
data.entry = entry;

%% Render the meshes
% Initialize
figure(1); clf; hold on;

% Render the liver as a patch object
patch(data.mesh.lv, ...
            'FaceColor',       [0.8 0.2 0.2], ...
            'EdgeColor',       'none',        ...
            'FaceLighting',    'gouraud',     ...
            'FaceAlpha',       0.5,           ...
            'AmbientStrength', 0.5);

% Render the hepatic veins as a patch object
patch(data.mesh.obs(1), ...
            'FaceColor',      [0.2 0.2 0.9], ...
            'EdgeColor',       'none',        ...
            'FaceLighting',    'gouraud',     ...
            'FaceAlpha',       0.25,           ...
            'AmbientStrength', 0.5);

% Render the portal veins as a patch object
patch(data.mesh.obs(2), ...
            'FaceColor',      [0.2 0.9 0.2], ...
            'EdgeColor',       'none',        ...
            'FaceLighting',    'gouraud',     ...
            'FaceAlpha',       0.25,           ...
            'AmbientStrength', 0.5);

% Fix the axes scaling, and set a nice view angle
axis('image');
axis([-70 180 -100 140 -100 100]);
daspect([1 1 1]);

% Add a camera light, and tone down the specular highlighting
view([155 20]);
camlight('headlight');
material('dull');

% Draw the insertion sheaths
R = 2;
N = 50;
for i = 1:2
    [X, Y, Z] = cylinder2P(R, N,entry(i).p1',entry(i).p2');
    fv(i) = surf2patch(X,Y,Z);
    
    % Render the sheath as a patch object
    patch(fv(i), ...
            'FaceColor',       [0.2 0.2 0.2], ...
            'EdgeColor',       'none',        ...
            'FaceLighting',    'gouraud',     ...
            'FaceAlpha',       1,           ...
            'AmbientStrength', 1);
    
end
% Label the axes
xlabel('x-direction');
ylabel('y-direction');
zlabel('z-direction');

% Format the plot
grid off;
axis off;
set(gcf,'color','w');

% Save the figure as a PDF
export_fig('Meshes3D.pdf');


