function [column_avg, gradient_data, maxpeaks, minpeaks] = cross_section_analysis(region, threshold, plot_msg)
    column_avg = zeros(1, length(region));
    for i=1:length(column_avg)
        column_avg(i) = mean(region(:, i));
    end
    gradient_data = smooth_gradient(column_avg);
    
    if nargin > 2
        len = length(gradient_data);
        newfigure(sprintf('region: %s', plot_msg));
        plot((1:len), column_avg,    'b', ...
             (1:len), gradient_data, 'r');
    end
    
    [maxpeaks, minpeaks] = peakdet(gradient_data, threshold);
end
