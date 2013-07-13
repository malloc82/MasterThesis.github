function surfaces_data = get_mri_tank_surfaces(coronal_set, sagittal_set)
    function [left_3d, right_3d] = convert(left_2d, right_2d, position, orientation, spacing)
        if isempty(left_2d)
            left_3d = []; 
        else 
            left_3d = dicom_coordinate(left_2d, position, orientation, spacing); 
        end
        if isempty(right_2d)
            right_3d = []; 
        else 
            right_3d = dicom_coordinate(right_2d, position, orientation, spacing); 
        end
    end

    function surface_data_3D = convert_surface_data(surface_data_2D, position, orientation, spacing)
        if isempty(surface_data_2D)
            surface_data_3D = []; 
        else 
            surface_data_2D = [surface_data_2D(:, 2) surface_data_2D(:, 1)];
            surface_data_3D = dicom_coordinate(surface_data_2D, position, orientation, spacing); 
        end
    end
    
    function [surfaces_data lefts rights] = get_surfaces(image_set)
        addpath('../../lib/');
        surfaces_data = struct();
        mid_sample_index = int32(length(image_set) / 2);
        mid_prev_sample  = dicomread(image_set{mid_sample_index-1});
        mid_sample       = dicomread(image_set{mid_sample_index});
        mid_next_sample  = dicomread(image_set{mid_sample_index+1});
        
        mid_image_sample = mid_prev_sample + mid_sample + mid_next_sample;
        
        surfaces_locations = locate_surfaces(mid_image_sample);
        fprintf('mid sample : %s\n', image_set{mid_sample_index});
        
        mid_info         = dicominfo(image_set{mid_sample_index});
        mid_spacing      = mid_info.PixelSpacing;
        mid_position     = mid_info.ImagePositionPatient;
        mid_orientation  = mid_info.ImageOrientationPatient;
        
        
        regions = get_surface_regions(mid_image_sample, surfaces_locations);
        [left right mid_boundary_info] = ...
            find_surface_boundary(regions.S2, []);
        
        % row = (upper_layer + lower_layer) / 2.0;
        row = (regions.S2_up + regions.S2_down) / 2.0;
        
        [lefts rights]   = convert([left  row], [right row], mid_position, mid_orientation, mid_spacing)
        s_data           = surface_edge(regions.S4, [left, right], 'S4');
        s_data(:, 1)     = s_data(:, 1) + regions.S4_up;
        surfaces_data.S4 = convert_surface_data(s_data, mid_position, mid_orientation, mid_spacing);
        
        fprintf('\n========== pass 1 start ===========\n');
        prev_boundaries = mid_boundary_info;
        prev_sample = mid_sample;
        curr_sample = mid_next_sample;
        println_vector('initial boundary_info ', prev_boundaries, 1);
        fprintf('\n');

        radius = int32(length(image_set) * 0.50 / 2)
        
        % for i=mid_sample_index+1:length(image_set)-1
        for i=mid_sample_index+1:mid_sample_index+radius
            next_sample = dicomread(image_set{i+1});
            sample      = (prev_sample + curr_sample + next_sample) / 3;
            regions     = get_surface_regions(sample, surfaces_locations);
            
            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;
            
            fprintf('i = %3d: ', i);
            [left right prev_boundaries] = ...
                find_surface_boundary(regions.S2, prev_boundaries);
            
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');

            s_data           = surface_edge(regions.S4, [left, right], 'S4');
            s_data(:, 1)     = s_data(:, 1) + regions.S4_up;
            surfaces_data.S4 = [surfaces_data.S4;
                                convert_surface_data(s_data, position, orientation, spacing)];
            
            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, position, orientation, spacing);
            lefts  = [lefts;  left_3d];
            rights = [rights; right_3d];
            
            prev_sample = curr_sample;
            curr_sample = next_sample;
        end % for 

        fprintf('\n========== pass 2 start ===========\n');
        prev_boundaries = mid_boundary_info;
        prev_sample = mid_sample;
        curr_sample = mid_prev_sample;
        println_vector('initial boundary_info ', prev_boundaries, 1);
        fprintf('\n');
        
        % for i=mid_sample_index-1:-1:2
        for i=mid_sample_index-1:-1:mid_sample_index-radius
            next_sample = dicomread(image_set{i-1});
            sample      = (prev_sample + curr_sample + next_sample) / 3;
            regions     = get_surface_regions(sample, surfaces_locations);
            
            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;
            
            fprintf('i = %3d: ', i);
            [left right prev_boundaries] = ...
                find_surface_boundary(regions.S2, prev_boundaries);
            
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');

            s_data           = surface_edge(regions.S4, [left, right], 'S4');
            s_data(:, 1)     = s_data(:, 1) + regions.S4_up;
            surfaces_data.S4 = [surfaces_data.S4; 
                                convert_surface_data(s_data, position, orientation, spacing)];
            
            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, position, orientation, spacing);
            lefts  = [lefts;  left_3d];
            rights = [rights; right_3d];
            
            prev_sample = curr_sample;
            curr_sample = next_sample;
        end % for        
    end % get_surfaces

    [surfaces_data lefts rights] = get_surfaces(sagittal_set);
    newfigure('S4 surface plot');
    hold on
    grid on
    scatter3(surfaces_data.S4(:, 1), surfaces_data.S4(:, 2), surfaces_data.S4(:, 3), 'b');
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off

    newfigure('S2 boundary');
    hold on
    grid on

    if ~isempty(lefts)
        scatter3(lefts(:, 1),  lefts(:, 2),  lefts(:, 3),  'r'); 
    end
    if ~isempty(rights)
        scatter3(rights(:, 1), rights(:, 2), rights(:, 3), 'r'); 
    end
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off
end
