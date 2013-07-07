function [left, right] = get_vertical_tubes_locations(image_set, row_range)
    middle_block_avg = dicomread(image_set{int32(length(image_set)/2) - 20});
    for i=int32(length(image_set)/2)-19:int32(length(image_set)/2)+20
        middle_block_avg = middle_block_avg + dicomread(image_set{i});
    end
    middle_block_avg = middle_block_avg / 41;

    [column_avg, gradient_data, maxpeaks, minpeaks] = ...
        cross_section_analysis(middle_block_avg(row_range, :), 3.5);
    
    % minpeaks are right boundaries of the tubes, after - 5 pixels, 
    % it's about the center location of tubes.
    left  = minpeaks(1,   1) - 5; 
    right = minpeaks(end, 1) - 5;
    
    % A safe range will be left/right +/- 20 pixels
end
