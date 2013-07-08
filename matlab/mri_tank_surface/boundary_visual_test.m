function boundary_visual_test(image_set)
    addpath(sprintf('%s/%s', pwd, '../lib'));
    % image_set = getAllFiles(data_set_dir);
    
    % mid_sample_index = 110;
    mid_sample_index = int32(length(image_set) / 2);
    mid_prev_sample  = dicomread(image_set{mid_sample_index-1});
    mid_sample       = dicomread(image_set{mid_sample_index});
    mid_next_sample  = dicomread(image_set{mid_sample_index+1});
    
    mid_image_sample = mid_prev_sample + mid_sample + mid_next_sample;
        
    tank_surfaces = locate_surfaces(mid_image_sample);
    fprintf('mid sample : %s\n', image_set{mid_sample_index});
    
    mid_info         = dicominfo(image_set{mid_sample_index});
    mid_spacing      = mid_info.PixelSpacing;
    mid_position     = mid_info.ImagePositionPatient;
    mid_orientation  = mid_info.ImageOrientationPatient;
    
    function [left_3d, right_3d] = convert(left_2d, right_2d, position, orientation, spacing)
        if isempty(left_2d), left_3d = []; else, left_3d = dicom_coordinate(left_2d, position, orientation, spacing); end
        if isempty(right_2d), right_3d = []; else, right_3d = dicom_coordinate(right_2d, position, orientation, spacing); end
    end
    
    function [left_bounds right_bounds] = surface_edge(upper_layer, lower_layer, plot_data, msg)
        region = mid_image_sample(upper_layer:lower_layer, :);

        [left right mid_boundary_info] = find_surface_boundary(region, [], plot_data, ...
                                                          strcat(msg, '_mid'));
        
        % This row value is for testing purpose only.
        row = (upper_layer + lower_layer) / 2.0;
        display('here');
        [left_bounds right_bounds] = convert([left  row], ...
                                             [right row], ...
                                             mid_position, mid_orientation, mid_spacing);

        
        fprintf('\n========== pass 1 start ===========\n');
        prev_boundaries = mid_boundary_info;
        prev_sample = mid_sample;
        curr_sample = mid_next_sample;
        println_vector('initial boundary_info ', prev_boundaries, 1);
        fprintf('\n');

        radius = int32(length(image_set) * 0.58 / 2)
        
        % for i=mid_sample_index+1:length(image_set)-1
        for i=mid_sample_index+1:mid_sample_index+radius
            next_sample = dicomread(image_set{i+1});

            region = (prev_sample(upper_layer:lower_layer, :) + ...
                      curr_sample(upper_layer:lower_layer, :) + ...
                      next_sample(upper_layer:lower_layer, :)) / 3;
            
            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;

            fprintf('i = %3d: ', i);
            [left right prev_boundaries] = find_surface_boundary(region, prev_boundaries, 0, ...
                                                              strcat(msg, '_', int2str(i)));
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');
            
            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, position, orientation, spacing);
            left_bounds  = [left_bounds;  left_3d];
            right_bounds = [right_bounds; right_3d];
            
            prev_sample = curr_sample;
            curr_sample = next_sample;
        end
        
        fprintf('\n========== pass 2 start ===========\n');
        prev_boundaries = mid_boundary_info;
        prev_sample = mid_sample;
        curr_sample = mid_prev_sample;
        println_vector('initial boundary_info ', prev_boundaries, 1);
        fprintf('\n');

        % for i=mid_sample_index-1:-1:2
        for i=mid_sample_index-1:-1:mid_sample_index-radius
            next_sample = dicomread(image_set{i-1});
            
            region = (prev_sample(upper_layer:lower_layer, :) + ...
                      curr_sample(upper_layer:lower_layer, :) + ...
                      next_sample(upper_layer:lower_layer, :)) / 3;

            % sample = dicomread(image_set{i});
            % region = sample(upper_layer:lower_layer, :);
            
            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;

            fprintf('i = %3d: ', i);
            [left right prev_boundaries] = find_surface_boundary(region, prev_boundaries, 0, ...
                                                              strcat(msg, '_', int2str(i)));
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');

            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, position, orientation, spacing);
            left_bounds  = [left_bounds;  left_3d];
            right_bounds = [right_bounds; right_3d];
            
            prev_sample = curr_sample;
            curr_sample = next_sample;
        end 
        
    end 
    
    % S1_up   = tank_surfaces.exterior_outside_upper;
    % S1_down = tank_surfaces.exterior_outside_lower;
    % [S1_left, S1_right] = surface_edge(S1_up, S1_down, 0, 'exterior outside');
    
    % S2_up   = tank_surfaces.exterior_inside_upper;
    % S2_down = tank_surfaces.exterior_inside_lower;
    % [S2_left, S2_right] = surface_edge(S2_up, S2_down, 0, 'exterior inside');
    
    S3_up   = tank_surfaces.inferior_outside_upper;
    S3_down = tank_surfaces.inferior_outside_lower;
    [S3_left, S3_right] = surface_edge(S3_up, S3_down, 0, 'inferior outside');
    
    % S4_up   = tank_surfaces.inferior_inside_upper;
    % S4_down = tank_surfaces.inferior_inside_lower;
    % [S4_left, S4_right] = surface_edge(S4_up, S4_down, 1, 'inferior inside');

    newfigure('Tank boundary test');
    hold on
    grid on
    % if ~isempty(S1_left),  scatter3(S1_left(:, 1),  S1_left(:, 2),  S1_left(:, 3),  'b'); end
    % if ~isempty(S1_right), scatter3(S1_right(:, 1), S1_right(:, 2), S1_right(:, 3), 'b'); end
    
    % if ~isempty(S2_left),  scatter3(S2_left(:, 1),  S2_left(:, 2),  S2_left(:, 3),  'b'); end
    % if ~isempty(S2_right), scatter3(S2_right(:, 1), S2_right(:, 2), S2_right(:, 3), 'b'); end

    if ~isempty(S3_left),  scatter3(S3_left(:, 1),  S3_left(:, 2),  S3_left(:, 3),  'b'); end
    if ~isempty(S3_right), scatter3(S3_right(:, 1), S3_right(:, 2), S3_right(:, 3), 'b'); end
        
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off
end
