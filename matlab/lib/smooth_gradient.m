function [smoothed_data_gradient, smoothed_data] = smooth_gradient(input, smooth)
    %% 'smooth' is optional
    gaussFilter = gausswin(7)';
    gaussFilter = gaussFilter / sum(gaussFilter);

    smoothed_data = conv(input, gaussFilter);
    smoothed_data = smoothed_data(4:end-3);

    smoothed_data_gradient = conv([1 0 -1], smoothed_data);
    smoothed_data_gradient = smoothed_data_gradient(2:end-1);
    
    if nargin > 1 && smooth == 1
        smoothed_gradient      = conv(smoothed_data_gradient, gaussFilter);
        smoothed_data_gradient = smoothed_gradient(4:end-3);
    end
end
