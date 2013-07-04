function boundary_visual_test_single(data_set_dir, index, boundary_info)
    addpath(sprintf('%s/%s', pwd, '../lib'));
    image_set = getAllFiles(data_set_dir);
    
    mid_sample_index = int32(length(image_set) / 2);
    mid_prev_sample  = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index-1}));
    mid_sample       = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index}));
    mid_next_sample  = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index+1}));
    mid_image_sample = mid_prev_sample + mid_sample + mid_next_sample;
        
    tank_surfaces = locate_surfaces(mid_image_sample);
    fprintf('mid sample : %s/%s\n', data_set_dir, image_set{mid_sample_index});
    
    mid_info         = dicominfo(image_set{mid_sample_index});
    mid_spacing      = mid_info.PixelSpacing;
    mid_position     = mid_info.ImagePositionPatient;
    mid_orientation  = mid_info.ImageOrientationPatient;
    
    function [left_3d, right_3d] = convert(left_2d, right_2d, position, orientation, spacing)
        if isempty(left_2d), left_3d = []; else, left_3d = dicom_coordinate(left_2d, position, orientation, spacing); end
        if isempty(right_2d), right_3d = []; else, right_3d = dicom_coordinate(right_2d, position, orientation, spacing); end
    end
    
    function [left_bounds right_bounds] = surface_edge(upper_layer, lower_layer, plot_data, msg)
        im_data_prev = dicomread(sprintf('%s/%s', data_set_dir, image_set{index-1}));
        im_data_curr = dicomread(sprintf('%s/%s', data_set_dir, image_set{index}));
        im_data_next = dicomread(sprintf('%s/%s', data_set_dir, image_set{index+1}));
        
        im_data = im_data_prev + im_data_curr + im_data_next;
        region = im_data(upper_layer:lower_layer, :);

        newfigure('region');
        imshow(region, []);

        [left right new_boundary_info] = find_surface_boundary(region, boundary_info, plot_data, msg)
        
        % This row value is for testing purpose only.
        row = (upper_layer + lower_layer) / 2.0;
        [left_bounds right_bounds] = convert([left  row], ...
                                             [right row], ...
                                             mid_position, mid_orientation, mid_spacing);
    end 
    
    % S1_up   = tank_surfaces.exterior_outside_upper;
    % S1_down = tank_surfaces.exterior_outside_lower;
    % [S1_left, S1_right] = surface_edge(S1_up, S1_down, 0, 'exterior outside')
    
    S2_up   = tank_surfaces.exterior_inside_upper;
    S2_down = tank_surfaces.exterior_inside_lower;
    [S2_left, S2_right] = surface_edge(S2_up, S2_down, 0, strcat('exterior inside slice #', int2str(index)));
    
    % S3_up   = tank_surfaces.inferior_outside_upper;
    % S3_down = tank_surfaces.inferior_outside_lower;
    % [S3_left, S3_right] = surface_edge(S3_up, S3_down, 1, 'inferior outside');
    
    % S4_up   = tank_surfaces.inferior_inside_upper;
    % S4_down = tank_surfaces.inferior_inside_lower;
    % [S4_left, S4_right] = surface_edge(S4_up, S4_down, 1, 'inferior inside');

    % newfigure('Tank boundary test');
    % hold on
    % grid on
    % if ~isempty(S1_left),  scatter3(S1_left(:, 1),  S1_left(:, 2),  S1_left(:, 3),  'b'); end
    % if ~isempty(S1_right), scatter3(S1_right(:, 1), S1_right(:, 2), S1_right(:, 3), 'b'); end

    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % hold off
end
