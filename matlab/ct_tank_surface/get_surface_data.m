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
