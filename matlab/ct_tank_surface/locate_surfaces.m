function  tank_surfaces = locate_surfaces(image_data)
    plot_data = 0;
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
        % plot((1:row), sample_smooth, 'b', ...
        %      (1:row), sample_gradient_smooth, 'r');
        plot((1:row), sample_gradient_smooth, 'r');
    end

    [maxpeaks, minpeaks] = peakdet(sample_gradient_smooth, 40)

    if length(maxpeaks) == 0 || length(minpeaks) == 0
        tank_surfaces = [];
        return;
    end
    
    filtered_maxpeaks = maxpeaks(maxpeaks(:, 2) <  210, :)
    filtered_minpeaks = minpeaks(minpeaks(:, 2) > -210, :)

    tank_surfaces = struct('exterior_outside_upper', filtered_minpeaks(1,1)-5, ...
                           'exterior_outside_lower', filtered_minpeaks(1,1)+5, ...
                           'exterior_outside_mid',   filtered_minpeaks(1,1), ...
                           'exterior_inside_upper',  filtered_maxpeaks(1,1)-5, ...
                           'exterior_inside_lower',  filtered_maxpeaks(1,1)+5, ...
                           'exterior_inside_mid',    filtered_maxpeaks(1,1), ...
                           'inferior_outside_upper', filtered_minpeaks(end,1)-5, ...
                           'inferior_outside_lower', filtered_minpeaks(end,1)+5, ...
                           'inferior_outside_mid',   filtered_minpeaks(end,1), ...
                           'inferior_inside_upper',  filtered_maxpeaks(end,1)-5, ...
                           'inferior_inside_lower',  filtered_maxpeaks(end,1)+5, ...
                           'inferior_inside_mid',    filtered_maxpeaks(end,1), ...
                           'sample_column',          sample_point, ...
                           'sample_width',           sample_width);
end
