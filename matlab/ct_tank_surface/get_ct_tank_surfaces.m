function [S1 S2 S3 S4] = get_ct_tank_surfaces(data_set_dir, image_file)
    addpath(sprintf('%s/%s', pwd, '../lib'));
    if nargin == 1
        image_set = getAllFiles(data_set_dir);
        mid_sample_index = int32(length(image_set) / 2);
        mid_image_sample = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index}));
        
        surfaces_locations = locate_surfaces(mid_image_sample);
        fprintf('mid sample : %s/%s\n', data_set_dir, image_set{mid_sample_index});
        image_filename = fprintf('%s/%s', data_set_dir, image_set{200});
        % for i=1:length(image_set)
        %     fprintf('%s\n', image_set{i});
        % end
        
        S1 = [];
        S2 = [];
        S3 = [];
        S4 = [];
    else 
        % mid_image = dicomread(sprintf('%s/%s', '../data/ct_5345_sagittal', '20121017_250.dcm'));
        mid_image = dicomread(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_250.dcm'));
        
        newfigure('original mid slice');
        imshow(mid_image, []);
        
        surfaces_locations = locate_surfaces(mid_image);

        image_filename = sprintf('%s/%s', data_set_dir, image_file);
        image_data = dicomread(image_filename);

        newfigure('original image');
        imshow(image_data, []);
        
        if isempty(surfaces_locations)
            display('surface locations empty');
            S1 = [];
            S2 = [];
            S3 = [];
            S4 = [];
            return;
        end
        [S1 S2 S3 S4] = get_surface_data(image_filename, surfaces_locations);
        mark_image(image_data, {S1 S2 S3 S4}, sprintf('marked : %s', image_filename));
    end
end

function spacing_mask = pixelspacing_mask(pixelspacing, mask)
% mask is [3, 1] vector
    spacing_mask = zeros(3, 1);
    if mask(1) == 1
        spacing_mask(1)   = pixelspacing(1);
        spacing_mask(2:3) = pixelspacing(2)*mask(2:3);
    else
        spacing_mask(2:3) = pixelspacing;
    end
end
