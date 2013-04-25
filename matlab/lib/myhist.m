function [values, count] = myhist(vector, plot_data)
    if nargin == 1
        plot_data = 0;
    end
    if min(size(vector)) > 1
        vector = vector(:)';
    end
    max_value = max(vector)
    min_value = min(vector)
    
    values = (int32(min_value):1:int32(max_value));
    count  = zeros(size(values));
    
    for c=1:length(vector)
        diff = int32(vector(c) - min_value);
        i = diff + 1;
        count(i) = count(i) + 1;
    end
    if plot_data ~= 0
        newfigure('Histogram');
        plot(values, count, 'r');
    end
end
