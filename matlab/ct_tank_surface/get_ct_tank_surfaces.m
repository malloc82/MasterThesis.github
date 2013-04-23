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
        mid_image = dicomread(sprintf('%s/%s', '../data/ct_5346_coronal', '20121017_250.dcm'));
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

function  tank_surfaces = locate_surfaces(image_data)
    plot_data = 1;
    [row, col] = size(image_data);

    sample_point = idivide(int32(col), 2);
    sample_width = 3;

    data_points = zeros([1, row]);
    for r=1:row
        % data_points(r) = mean(image_region(r, (sample_point-1):(sample_point+1)));
        data_points(r) = mean(image_data(r, (sample_point-sample_width):(sample_point+sample_width)));
    end

    % data_points = image_region(:, sample_point)';
    % if plot_data == 1
    %     newfigure('raw data')
    %     plot((1:row), data_points)
    % end

    %% smooth data point
    % sample_data = sample(:, sample_point)';
    
    [sample_gradient_smooth, sample_smooth] = smooth_gradient(data_points, 1);
    
    if plot_data == 1
        newfigure('smooth sample & smooth data points');
        plot((1:row), sample_smooth, 'b', ...
             (1:row), sample_gradient_smooth, 'r');
    end

    [maxpeaks, minpeaks] = peakdet(sample_gradient_smooth, 40);

    if length(maxpeaks) == 0 || length(minpeaks) == 0
        tank_surfaces = [];
        return;
    end
    
    filtered_maxpeaks = maxpeaks(maxpeaks(:, 2) <  100, :);
    filtered_minpeaks = minpeaks(minpeaks(:, 2) > -100, :);

    tank_surfaces = struct('exterior_outside_upper', filtered_minpeaks(1,1)-5, ...
                           'exterior_outside_lower', filtered_minpeaks(1,1)+5, ...
                           'exterior_inside_upper',  filtered_maxpeaks(1,1)-5, ...
                           'exterior_inside_lower',  filtered_maxpeaks(1,1)+5, ...
                           'inferior_outside_upper', filtered_minpeaks(end,1)-5, ...
                           'inferior_outside_lower', filtered_minpeaks(end,1)+5, ...
                           'inferior_inside_upper',  filtered_maxpeaks(end,1)-5, ...
                           'inferior_inside_lower',  filtered_maxpeaks(end,1)+5);
end

function [S1 S2 S3 S4] = get_surface_data(image_filename, surface_locations)
    image_data = dicomread(image_filename);
    image_info = dicominfo(image_filename);
    
    function edge_pixels = edge_pixels_canny(upper_layer, lower_layer, plot_data, msg)
        edge_pixels = [];
        region = image_data(upper_layer:lower_layer, :);
        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('surface region: %s', msg));
            imshow(region, []);
        end
        
        if nargin < 3, msg = ''; end
        [left_bound, right_bound] = find_surface_boundary(region, plot_data, msg);
        if isempty(left_bound) || isempty(right_bound)
            fprintf('empty : %s\n', msg);
            return;
        end

        
        %% test 
        [tank_edge threshold] = edge(region, 'canny', [0.001 0.002]);
        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('edge: %s', msg));
            imshow(tank_edge, []);
        end
        threshold;
        tank_edge = remove_short_lines(tank_edge);

        % tank_edge = remove_short_lines(edge(region, 'canny', [0.005 0.01]));

        % tank_edge = edge(region, 'canny', [0.01 0.02]);

        %% end         
        
        [row, col] = size(region);
        h_edges = zeros(row, col);
        for r=1:row
            for c=1:col
                if tank_edge(r, c) > 0 && (c > left_bound+2 && c < right_bound-2)
                    h_edges(r, c) = tank_edge(r, c);
                end
            end
        end
        
        % h_edges = remove_vertical_edges(h_edges);
        for r=1:row
            for c=1:col
                if h_edges(r, c) > 0
                    edge_pixels = [edge_pixels; [r c]];
                end
            end
        end
        if ~isempty(edge_pixels)
            edge_pixels = filter_flat_surface(edge_pixels);
            edge_pixels(:, 1) = edge_pixels(:, 1) + (upper_layer - 1);
        end
    end
    
    function edge_pixels = edge_pixels_peaks(upper_layer, lower_layer, plot_data, msg)
        edge_pixels = [];
        region = image_data(upper_layer:lower_layer, :);
        
        [left_bound, right_bound] = find_surface_boundary(region, plot_data, msg)
        if isempty(left_bound) || isempty(right_bound)
            fprintf('empty : %s\n', msg);
            return;
        end
        edge_length = right_bound - left_bound;

        % surface_region = smooth_image(surface_region);
        for col=(1:edge_length-1) + left_bound
            row = vertical_boundary(region(:, col));
            if ~isnan(row)
                edge_pixels = [ edge_pixels; [row col] ];
            end
        end
        if ~isempty(edge_pixels)
            edge_pixels(:, 1) = edge_pixels(:, 1) + (upper_layer - 1);
        end
    end
    
    S1_up   = surface_locations.exterior_outside_upper;
    S1_down = surface_locations.exterior_outside_lower;

    S2_up   = surface_locations.exterior_inside_upper;
    S2_down = surface_locations.exterior_inside_lower;

    S3_up   = surface_locations.inferior_outside_upper;
    S3_down = surface_locations.inferior_outside_lower;    
    
    S4_up   = surface_locations.inferior_inside_upper;
    S4_down = surface_locations.inferior_inside_lower;
    
    display('Surface 1');
    S1 = edge_pixels_canny(S1_up, S1_down, 0, 'Exterior outside surface');
    display('Surface 2');
    S2 = edge_pixels_canny(S2_up, S2_down, 0, 'Exterior inside surface');
    display('Surface 3');
    S3 = edge_pixels_canny(S3_up, S3_down, 0, 'Inferior outside surface');
    display('Surface 4');
    S4 = edge_pixels_canny(S4_up, S4_down, 0, 'Inferior inside surface');
    
    % S2 = image_data(S2_up:S2_down, :);
    % S3 = image_data(S3_up:S3_down, :);

end

function S_out = filter_flat_surface(S_in)
    mk = [S_in(:, 2) ones(length(S_in), 1)] \ S_in(:, 1);
    S_out = S_in(abs(mk(1) * S_in(:, 2) + mk(2) - S_in(:, 1)) <= 1, :); 
end

function [left, right] = find_surface_boundary(surface_region, plot_data, msg)
    cutoff = 5;
    column_sums = zeros(1, length(surface_region));
    for i=1:length(column_sums)
        column_sums(i) = sum(surface_region(:, i));
    end
    gradient_data = smooth_gradient(column_sums);
    if nargin >= 2 && plot_data == 1
        if nargin == 3
            newfigure(sprintf('surface data: %s', msg));
        else 
            newfigure('surface data')
        end
        plot((1:length(gradient_data)), column_sums, 'b', ...
             (1:length(gradient_data)), gradient_data, 'r');
    end
    [maxpeaks, minpeaks] = peakdet(gradient_data, 250);
    
    % maxpeaks(maxpeaks(:, 2) < 1000 & maxpeaks(:, 2) > 250, :);

    % boundary threshold
    right = maxpeaks(maxpeaks(:, 2) <  1000 & maxpeaks(:, 2) >  250, 1);
    [c i] = max(column_sums(right));
    right = right(i);

    left  = minpeaks(minpeaks(:, 2) > -1000 & minpeaks(:, 2) < -250, 1);
    [c i] = max(column_sums(left));
    left = left(i);
end

function boundary = vertical_boundary(column_data) % , edge_type)
    column_gradient = conv([-1 0 1], double(column_data'));
    column_gradient = column_gradient(2:end-1);

    [maxpeaks, minpeaks] = peakdet(column_gradient, 20);
    [row, col] = size(maxpeaks);
    % if row > 1
    %     maxpeaks
    %     newfigure('vertical_boundary test')
    %     plot(1:length(column_data), column_gradient, 'r');
    % end
    if row == 0
        boundary = NaN;
    else
        % if strcmp(edge_type, 'outside')
        if column_data(1) > column_data(2)
            if isempty(maxpeaks)
                boundary = NaN;
            else 
                boundary = max(maxpeaks(maxpeaks(:, 2) > 20, 1));
            end
        % elseif  strcmp(edge_type, 'inside')
        elseif  column_data(1) < column_data(2)
            if isempty(minpeaks)
                boundary = NaN;
            else 
                boundary = min(minpeaks(minpeaks(:, 2) < -20, 1));
            end
        else
            boundary = NaN;
        end
    end
    % boundary = maxpeaks(1,1);
end
