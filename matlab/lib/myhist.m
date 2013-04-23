function [values, count] = myhist(vector, plot_data)
    if nargin == 1
        plot_data = 0;
    end
    [row col] = size(vector);
    if row > 1
        vector = vector(:)';
    end
    max_value = max(vector);
    min_value = min(vector);
    
    values = (int32(min_value)+1:1:int32(max_value));
    count  = zeros(size(values));
    [row col] = size(values);
    
    for c=1:col
        diff = int32(vector(c) - min_value);
        if diff >= 1
            i = diff + 1;
            count(i) = count(i) + 1;
        end
    end
    if plot_data ~= 0
        newfigure('Histogram');
        plot(values, count, 'r');
    end
end
