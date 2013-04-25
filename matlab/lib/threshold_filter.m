function filtered_data = threshold_filter(input_data, threshold)
    [row col] = size(input_data);
    filtered_data = zeros(row, col);
    if length(threshold) == 2
        upper_bound = max(threshold);
        lower_bound = min(threshold);
        for r=1:row
            for c=1:col
                if input_data(r, c) > lower_bound && input_data(r, c) < upper_bound
                    filtered_data(r, c) = input_data(r, c);
                end
            end
        end
    else         
        for r=1:row
            for c=1:col
                if input_data(r, c) > threshold
                    filtered_data(r, c) = input_data(r, c);
                end
            end
        end
    end
end
