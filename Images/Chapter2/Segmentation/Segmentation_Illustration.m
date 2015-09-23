% -------------------------------------------------------------------------
% author: Troy Adebar
% date: 2013-05-20
%
% title: Segmentation_Illustration
%
% summary: This .m file produces a 2x1 subimage showing the 2D power
% Doppler segmentation algorithm used in the 2013 TRO paper.
% -------------------------------------------------------------------------
%% Load Data
clear all; close all;
% define constants
order = 3; % for curve fitting
% -------------------------------------------------------------------------
% - - - - - - -  Get these values from propello window! - - - - - - - - - -
% -------------------------------------------------------------------------
filename = '1_auto_colorpost.vol';
folder = '';
datapath = [folder filename]; % The file saved in propello
whichVol = 1; % Of the volumes saved in datapath, which one will be read in
degPerFr = 0.731; % Angular increment (deg) between frames
imgDepth = 100; % Imaging depth in mm
probeR3D_mm = 27.25; % 3D probe radius in mm
probeR2D_mm = 40; % 2D image radius in mm
micr_x = 238; % Microns per image pixel in the x direction
micr_y = 238; % Microns per image pixel in the y direction
o_x = 241; % Position of the image origin in the x direction
o_y = 40; % Position of the image origin in the y direction
sect_ang = 75.85; % Arc of 2D image in degrees
% -------------------------------------------------------------------------
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% -------------------------------------------------------------------------

% Load the volume information and data from the file
[volume, hdr] = loadvol(datapath, whichVol);
% Check that it's post-scan data as expected
if(hdr.datatype ~= 4)
    display('Error: Data not read in as post-scan B/color')
else
    % Initialize some matrices
    pts = []; guess = []; needle_loc = []; errors = [];
    Col = zeros(hdr.h,hdr.w,hdr.fpV); BW = Col;
    % Loop through slices in the volume and search for needle
    SS = [];
    %     for slice = 1:hdr.fpV
    for slice = 41;
        %% Isolate the color data
        [m_RGB_image, m_Col_image] = separatecolor(volume(:,:,slice)');
        m_Gray_image = rgb2gray(m_Col_image); % grayscale Doppler
        %% Process Doppler data
        % Theshold Doppler data at 5/255 intensity level
        m_BW_image = im2bw(m_Col_image,5/255);
        % Remove pixel groups with less than 300 pixels total area
        m_BW_raw = m_BW_image;
        m_BW_image2 = bwareaopen(m_BW_image,300);
        m_BW_image = m_BW_image2;
        m_Gray_image(~m_BW_image) = 0; m_Gray_image = double(m_Gray_image);
        % Save Doppler data for visualization
        Col(:,:,slice) = m_Gray_image;
        BW(:,:,slice) = m_BW_image;
        %% Use centroid of the Doppler data as the needle
        if(sum(sum(m_Gray_image)))
            [rows cols] = size(m_Gray_image);
            y = 1:rows; x = 1:cols; [X Y] = meshgrid(x,y);
            x_bar = sum(sum(X.*m_Gray_image))/sum(sum(m_Gray_image));
            y_bar = new_find_quarter_point(m_Gray_image,0.25);
            [m,n] = size(m_BW_image);
            pts = [pts; x_bar,y_bar,slice,1];
            
            %% Display raw image and segmentation
            fntSize = 32;
            % Display the B+color image
            m_xlim = [200 300]; m_ylim = [175 325];
            fig = figure(1);
            f1 = subplot(121); hold off; image(m_RGB_image); axis image; axis off;
            hold on; 
%             h = title('POWER DOPPLER');
%             set(h,'FontSize',fntSize,'FontName','Times New Roman');
            set(gca, 'XLim', m_xlim, 'YLim', m_ylim)
            % Display the outline image     
            m_blank_image = ones(hdr.h,hdr.w); m_blank_image(o_y,o_x) = 0;
            f2 = subplot(122); hold off; imagesc(m_blank_image);
            axp2 = get(f2,'position');
            axis image; axis off; colormap(gray);
            hold on; 
%             h = title('SEGMENTATION');
%             set(h,'FontSize',fntSize,'FontName','Times New Roman');
            set(gca, 'XLim', m_xlim, 'YLim', m_ylim)
            set(f2,'position',axp2-[0.075 0 0 0]);
            % plot the Doppler outline of omitted data
            B = bwboundaries(m_BW_raw);
            P = size(B);
            doppColor = [1 0.5 0];
            for p = 1:P
                plot(B{p}(:,2), B{p}(:,1), ':','Color',doppColor,'LineWidth',3); hold on;
%                 patch(B{p}(:,2), B{p}(:,1),[0.5 0.5 0.5]); hold on;
            end
            % plot the actual Doppler outline
            B = bwboundaries(m_Gray_image);
            P = size(B);
            for p = 1:P
                plot(B{p}(:,2), B{p}(:,1), '-','Color',doppColor,'LineWidth',3); hold on;
%                 patch(B{p}(:,2), B{p}(:,1),[1 0 0],'LineWidth',3); hold on;
            end
            % plot the outline of the ultrasound window
            sliceInt = 100;
            p_vol = find_vol_boundaries(imgDepth,probeR2D_mm,micr_x,micr_y,o_x,o_y,sect_ang,sliceInt);
            for k = 1:4
                edge_pts = p_vol{k};
                edge_pts(:,1) = max(edge_pts(:,1),1);
                edge_pts(:,1) = min(edge_pts(:,1),hdr.w);
                edge_pts(:,2) = max(edge_pts(:,2),1);
                edge_pts(:,2) = min(edge_pts(:,2),hdr.h);
                plot(edge_pts(:,1),edge_pts(:,2),'k','LineWidth',3);
            end
            % plot the resulting centroid point
            plot(x_bar,y_bar,'+','Color',[1 0 0],'LineWidth',4,'MarkerSize',30);
            plot(m_xlim([1 2 2 1 1]),m_ylim([1 1 2 2 1]),'k-','LineWidth',4);
            m_xlim = [200 300]; m_ylim = [175 325];
            set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
            set(fig,'color','w');
            export_fig Segmentation2D.pdf 
%             pause;
        end 
    end
end

%% Create 2D image of raw US data
rawI = m_RGB_image;
lgI = imresize(rawI,5);
imwrite(lgI,'Raw US.png');

