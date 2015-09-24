% Create figure to show meshes and reachability results

%% Visualize the reachable workspace in a 2D slice
% Initialize

% load v1FrontalSlice;
load FirstResults;


% Define color contours
cvals = [0 1 2];

% Define color map
cmap = [    0 0 0; 
            1 0 0; 
            0 1 0; 
            1 1 0    ];

% Show reachability of the fine mesh
figure(1); clf; hold on;
fineIm = data.fineVol.V;
fineIm = permute(fineIm,[1 3 2]);
fineIm = squeeze(fineIm);
% fineIm = flipud(fineIm);
fineIm = fliplr(fineIm);
% fineIm = rot90(fineIm,-1);
imagesc(fineIm);
colormap(cmap);
colorbar;
axis image; axis off;
title('Reachable workspace with \rho = 10 mm');

% Show minimum radius of the fine mesh
figure(2); clf; hold on;
CMAP = jet(64);

% Load the radius map and resize/rotate
reachIm = data.fineVol.R;
reachIm = permute(reachIm,[1 3 2]);
reachIm = squeeze(reachIm);
reachIm = fliplr(reachIm);
% reachIm = flipud(reachIm);
% reachIm = rot90(reachIm,-1);

% Convert to RGB color image
reachIm = imadjust(reachIm./200,[10/200; 200/200],[0; 1]);
[indIm,~] = gray2ind(reachIm);
colIm = ind2rgb(indIm,CMAP);

% Replace unreachable/external voxels with white/black
stacked = repmat(fineIm,[1 1 3]);
imSize = size(colIm);
outsideInd = find(stacked == -1);
colIm(outsideInd) = 1;
unreachInd = find(stacked == 0);
colIm(unreachInd) = 0;

% Resize the image
bigIm = imresize(colIm,10,'bicubic');
bigIm(bigIm > 1) = 1;
bigIm(bigIm < 0) = 0;

% Show the image
image(bigIm);

V=[0 1];
caxis(V); 

%set color map range 
colormap(CMAP);
hcb = colorbar('YTick', [16:16:64],'YTickLabel',...
    {'     50 mm',...
     '    100 mm',...
     '    150 mm',...
     '  > 200 mm'});


set(findall(gcf,'-property','FontSize'),'FontSize',20,...
    'fontName','Times New Roman')

set(gcf,'color','w');
axis image; axis off;

set(gcf,'units','normalized');
set(gcf,'position',[0.1 0.1 0.5 0.4]);

% Save the results figure
% export_fig('TransverseSlice.pdf');
