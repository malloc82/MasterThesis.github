function surfaces_data = get_mri_tank_surfaces(coronal_set, sagittal_set)
    function [left_3d, right_3d] = convert(left_2d, right_2d, im_info)
        if isempty(left_2d)
            left_3d = []; 
        else 
            left_3d = dicom_coordinate(left_2d, im_info.position, im_info.orientation, im_info.spacing); 
        end
        if isempty(right_2d)
            right_3d = []; 
        else 
            right_3d = dicom_coordinate(right_2d, im_info.position, im_info.orientation, im_info.spacing); 
        end
    end

    function surface_data_3D = convert_surface_data(surface_data_2D, im_info)
        if isempty(surface_data_2D)
            surface_data_3D = []; 
        else 
            surface_data_2D = [surface_data_2D(:, 2) surface_data_2D(:, 1)];
            surface_data_3D = dicom_coordinate(surface_data_2D, ...
                                               im_info.position, ...
                                               im_info.orientation, ...
                                               im_info.spacing);
        end
    end

    % surface numbers
    surface1 = 1;
    surface2 = 2;
    surface3 = 3;
    surface4 = 4;
    
    function [surfaces_data lefts rights] = get_surfaces(image_set, surfaces_number)
        addpath('../../lib/');

        surfaces_data = struct();
        surfaces_data.S1 = [];
        surfaces_data.S2 = [];
        surfaces_data.S3 = [];
        surfaces_data.S4 = [];
        function get_surfaces_edge(regions, boundary, surfaces, im_info)
            for i=1:length(surfaces)
                if surfaces(i) == surface1
                    s_data           = surface_edge(regions.S1, [left, right], 'S1');
                    s_data(:, 1)     = s_data(:, 1) + regions.S1_up;
                    surfaces_data.S1 = [surfaces_data.S1; convert_surface_data(s_data, im_info)];
                elseif surfaces(i) == surface2
                    s_data           = surface_edge(regions.S2, [left, right], 'S2');
                    s_data(:, 1)     = s_data(:, 1) + regions.S2_up;
                    surfaces_data.S2 = [surfaces_data.S2; convert_surface_data(s_data, im_info)];
                elseif surfaces(i) == surface3
                    s_data           = surface_edge(regions.S3, [left, right], 'S3');
                    s_data(:, 1)     = s_data(:, 1) + regions.S3_up;
                    surfaces_data.S3 = [surfaces_data.S3; convert_surface_data(s_data, im_info)];
                elseif surfaces(i) == surface4
                    s_data           = surface_edge(regions.S4, [left, right], 'S4');
                    s_data(:, 1)     = s_data(:, 1) + regions.S4_up;
                    surfaces_data.S4 = [surfaces_data.S4; convert_surface_data(s_data, im_info)];
                else 
                    error('Unrecognized surface number, it should be a subset of [1 2 3 4]');
                end 
            end
        end 
        
        function clean_data()
            if ~isempty(surfaces_data.S1)
                s = std(surfaces_data.S1(:, 3));
                m = mean(surfaces_data.S1(:, 3));
                surfaces_data.S1 = ...
                    surfaces_data.S1(surfaces_data.S1(:, 3) > m - 4*s & surfaces_data.S1(:, 3) < m + 4*s, :);
            end 
            if ~isempty(surfaces_data.S2)
                s = std(surfaces_data.S2(:, 3));
                m = mean(surfaces_data.S2(:, 3));
                surfaces_data.S2 = ...
                    surfaces_data.S2(surfaces_data.S2(:, 3) > m - 4*s & surfaces_data.S2(:, 3) < m + 4*s, :);
            end 
            if ~isempty(surfaces_data.S3)
                s = std(surfaces_data.S3(:, 3));
                m = mean(surfaces_data.S3(:, 3));
                surfaces_data.S3 = ...
                    surfaces_data.S3(surfaces_data.S3(:, 3) > m - 4*s & surfaces_data.S3(:, 3) < m + 4*s, :);
            end 
            if ~isempty(surfaces_data.S4)
                s = std(surfaces_data.S4(:, 3));
                m = mean(surfaces_data.S4(:, 3));
                surfaces_data.S4 = ...
                    surfaces_data.S4(surfaces_data.S4(:, 3) > m - 4*s & surfaces_data.S4(:, 3) < m + 4*s, :);
            end 
        end
        
        mid_sample_index = int32(length(image_set) / 2);
        mid_prev_sample  = dicomread(image_set{mid_sample_index-1});
        mid_sample       = dicomread(image_set{mid_sample_index});
        mid_next_sample  = dicomread(image_set{mid_sample_index+1});
        
        mid_image_sample = (mid_prev_sample + mid_sample + mid_next_sample) / 3;
        
        surfaces_locations = locate_surfaces(mid_image_sample);
        fprintf('mid sample : %s\n', image_set{mid_sample_index});
        
        mid_info = dicominfo(image_set{mid_sample_index});
        
        mid_slice_info             = struct();
        mid_slice_info.index       = mid_sample_index;
        mid_slice_info.spacing     = mid_info.PixelSpacing;
        mid_slice_info.position    = mid_info.ImagePositionPatient;
        mid_slice_info.orientation = mid_info.ImageOrientationPatient;
        
        regions = get_surface_regions(mid_image_sample, surfaces_locations);
        [left right mid_boundary_info] = find_surface_boundary(regions.S2, []);
        
        % row = (upper_layer + lower_layer) / 2.0;
        row = (regions.S2_up + regions.S2_down) / 2.0;
        
        [lefts rights]   = convert([left  row], [right row], mid_slice_info);
        get_surfaces_edge(regions, [left, right], surfaces_number, mid_slice_info);
                
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
            slice_info  = struct();
            slice_info.index       = i;
            slice_info.spacing     = im_info.PixelSpacing;
            slice_info.position    = im_info.ImagePositionPatient;
            slice_info.orientation = im_info.ImageOrientationPatient;
            
            fprintf('i = %3d: ', i);
            fprintf('Position: [%4.2f %4.2f %4.2f], ', ...
                    slice_info.position(1), slice_info.position(2), slice_info.position(3));
            [left right prev_boundaries] = find_surface_boundary(regions.S2, prev_boundaries);
            
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');

            
            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, slice_info);
            lefts  = [lefts;  left_3d];
            rights = [rights; right_3d];
            
            get_surfaces_edge(regions, [left, right], surfaces_number, slice_info);
            
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
            slice_info = struct(); 
            slice_info.index       = i;
            slice_info.spacing     = im_info.PixelSpacing;
            slice_info.position    = im_info.ImagePositionPatient;
            slice_info.orientation = im_info.ImageOrientationPatient;
            
            fprintf('i = %3d: ', i);
            fprintf('Position: [%4.2f %4.2f %4.2f], ', ...
                    slice_info.position(1), slice_info.position(2), slice_info.position(3));
            [left right prev_boundaries] = find_surface_boundary(regions.S2, prev_boundaries);
            
            if isempty(left),  fprintf(' left  is empty!! '); else fprintf('left  = %d, ', left),  end
            if isempty(right), fprintf(' right is empty!! '); else fprintf('right = %d, ', right), end
            fprintf('\n');

            get_surfaces_edge(regions, [left, right], surfaces_number, slice_info);
        
            if isempty(left),  left_2d  = []; else left_2d  = [left  row]; end;
            if isempty(right), right_2d = []; else right_2d = [right row]; end;
            [left_3d right_3d] = convert(left_2d, right_2d, slice_info);
            lefts  = [lefts;  left_3d];
            rights = [rights; right_3d];
            
            prev_sample = curr_sample;
            curr_sample = next_sample;
        end % for
        % clean_data();
    end % get_surfaces
    
    [surfaces_data lefts rights] = get_surfaces(sagittal_set, [1]);
    plot_all_surfaces_mri(surfaces_data);
    
    
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
