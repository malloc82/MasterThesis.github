function [upper_boundary, lower_boundary] = get_midtank_boundary(image_set_dir)    
    image_set = getAllFiles(image_set_dir);
    mid_index = int32(length(image_set) / 2);
    
    prev_sample = dicomread(image_set{mid_index-1});
    curr_sample = dicomread(image_set{mid_index});
    next_sample = dicomread(image_set{mid_index+1});
    
    sample = prev_sample + curr_sample + next_sample;
    [row, col] = size(sample);
    mid_column = sample(:, int32(col/2)-1) + sample(:, int32(col/2)) + sample(:, int32(col/2)+1);
    
    gaussFilter = gausswin(7)';
    gaussFilter = gaussFilter / sum(gaussFilter);
    sample_smooth = conv(mid_column, gaussFilter);
    sample_smooth = sample_smooth(4:end-3);

    sample_gradient = conv([-1 0 1], sample_smooth);
    sample_gradient = sample_gradient(2:end-1);

    sample_gradient_smooth = conv(sample_gradient, gaussFilter);
    sample_gradient_smooth = sample_gradient_smooth(4:end-3);

    [maxpeaks, minpeaks] = peakdet(sample_gradient_smooth, 150)
    plot((1:row), sample_smooth, 'b', ...
         (1:row), sample_gradient_smooth, 'r');
    
    upper_candidates = minpeaks(minpeaks(:, 1) < col/2 & minpeaks(:, 2) < -150, :)
    lower_candidates = maxpeaks(maxpeaks(:, 1) > col/2 & maxpeaks(:, 2) >  150, :)

    upper_boundary = upper_candidates(end, 1) - 20;    
    lower_boundary = lower_candidates(1,   1) + 20;
    
end % get_midtank_boundary
