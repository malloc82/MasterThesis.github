function [left, right] = find_surface_boundary(surface_region, plot_data, msg)
    cutoff = 5;
    column_sums = zeros(1, length(surface_region));
    for i=1:length(column_sums)
        column_sums(i) = sum(surface_region(:, i));
    end
    gradient_data = smooth_gradient(column_sums);
    if nargin >= 2 && plot_data == 1
        if nargin == 3
            newfigure(sprintf('surface data2: %s', msg));
        else 
            newfigure('surface data')
        end
        plot((1:length(gradient_data)), column_sums, 'b', ...
             (1:length(gradient_data)), gradient_data, 'r');
    end
    [maxpeaks, minpeaks] = peakdet(gradient_data, 250);
    
    % maxpeaks(maxpeaks(:, 2) < 1000 & maxpeaks(:, 2) > 250, :);

    % boundary threshold
    right = maxpeaks(maxpeaks(:, 2) <  1000 & maxpeaks(:, 2) >  200, 1);
    [c i] = max(column_sums(right));
    if column_sums(right(i)) < 0
        right = [];
        left  = [];
    else 
        right = right(i);
    end 
    % right = right(i);
    
    left  = minpeaks(minpeaks(:, 2) > -1000 & minpeaks(:, 2) < -200, 1);
    [c i] = max(column_sums(left));
    if column_sums(left(i)) < 0
        right = [];
        left  = [];
    else 
        left = left(i);
    end 
    % left = left(i);
end
