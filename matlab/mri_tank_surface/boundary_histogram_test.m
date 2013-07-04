function [column_averages, maxpeaks, minpeaks] = boundary_histogram_test(surface_region, plot_data, msg)
    column_averages = zeros(1, length(surface_region));
    for i=1:length(column_averages)
        column_averages(i) = mean(surface_region(:, i));
    end
    gradient_data = smooth_gradient(column_averages);
    
    % Test plot
    if nargin > 1 && plot_data == 1
        if nargin == 3
            newfigure(sprintf('surface region: %s', msg));
        else 
            newfigure('surface region');
        end
        plot((1:length(gradient_data)), column_averages, 'b', ...
             (1:length(gradient_data)), gradient_data, 'r');
    end
    
    [maxpeaks, minpeaks] = peakdet(gradient_data, 15);
    
end
