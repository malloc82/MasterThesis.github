function [S1 S2 S3 S4 boundaries_info] = get_surface_data(image_filename, surface_locations, surface_boundaries)
% surface_boundaries format: 
%    {[left1  right1  pixel_range1]
%     [left2  right2  pixel_range2]
%     [left3  right3  pixel_range3]
%     [left4  right4  pixel_range4]}
    
    image_data = dicomread(image_filename);
    image_info = dicominfo(image_filename);
    if nargin < 3
        surface_boundaries = {[], [], [], []};
    end
    
    function [edge_pixels boundary_info] = edge_pixels_canny(upper_layer, lower_layer, prev_boundaries, canny_threshold, plot_data, msg)
        edge_pixels = [];
        region = image_data(upper_layer:lower_layer, :);
        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('surface region: %s', msg));
            imshow(region, []);
        end
        
        if nargin <= 3, msg = ''; end
        [left_bound, right_bound, boundary_info] = find_surface_boundary(region, prev_boundaries, plot_data, msg);
        if isempty(left_bound) || isempty(right_bound)            
            % fprintf(': %s\n', msg);
            return;
        end
        
        %% edges 
        if isempty(canny_threshold)
            [tank_edge canny_threshold] = edge(region, 'canny');
        else 
            tank_edge = edge(region, 'canny', canny_threshold);
        end 
            
        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('raw edge: %s', msg));
            imshow(tank_edge, []);
        end
        % fprintf('Canny threshold = [%f, %f]\n', canny_threshold(1) canny_threshold(2));  
        tank_edge = remove_short_lines(tank_edge);

        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('without short edges: %s', msg));
            imshow(tank_edge, []);
        end                
        
        % tank_edge = remove_short_lines(edge(region, 'canny', [0.005 0.01]));

        % tank_edge = edge(region, 'canny', [0.01 0.02]);

        %% end         
        
        [row, col] = size(region);
        for r=1:row
            for c=1:col
                if ~(tank_edge(r, c) > 0 && (c > left_bound+2 && c < right_bound-2))
                    tank_edge(r, c) = 0;
                end
            end
        end
        if nargin >= 3 && plot_data == 1
            newfigure(sprintf('filtered edge: %s', msg));
            imshow(tank_edge, []);
        end        
        
        h_edges = cell(1, col);
        for r=1:row
            for c=1:col
                if tank_edge(r, c) > 0 && (c > left_bound+2 && c < right_bound-2)
                    edge_pixels = [edge_pixels; [r c]];
                end
            end
        end
                
        if ~isempty(edge_pixels)
            edge_pixels = filter_flat_surface(edge_pixels, col);
            edge_pixels(:, 1) = edge_pixels(:, 1) + (upper_layer - 1);
        end
    end
    
    function edge_pixels = edge_pixels_peaks(upper_layer, lower_layer, plot_data, msg)
        edge_pixels = [];
        region = image_data(upper_layer:lower_layer, :);
        
        [left_bound, right_bound] = find_surface_boundary(region, plot_data, msg)
        if isempty(left_bound) || isempty(right_bound)
            % fprintf('empty : %s', msg);
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
    
    fprintf('Surface 1: ');
    [S1 boundary1] = edge_pixels_canny(S1_up, S1_down, surface_boundaries{1}, [0.001, 0.002], ...
                                       0, 'Exterior outside surface');
    fprintf('\n');
    
    fprintf('Surface 2: ');
    [S2 boundary2] = edge_pixels_canny(S2_up, S2_down, surface_boundaries{2}, [0.001, 0.002], ...
                                       0, 'Exterior inside surface');
    fprintf('\n');;
    
    fprintf('Surface 3: ');
    [S3 boundary3] = edge_pixels_canny(S3_up, S3_down, surface_boundaries{3}, [0.001, 0.002], ...
                                       0, 'Inferior outside surface');
    fprintf('\n');;
    
    fprintf('Surface 4: ');
    [S4 boundary4] = edge_pixels_canny(S4_up, S4_down, surface_boundaries{4}, [], ...
                                       0, 'Inferior inside surface');
    fprintf('\n');;

    boundaries_info = {boundary1 boundary2 boundary3 boundary4};
    
    % S2 = image_data(S2_up:S2_down, :);
    % S3 = image_data(S3_up:S3_down, :);
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
