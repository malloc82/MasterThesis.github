function result = remove_vertical_edges(input_data)
    average_pixel = 0;
    pixel_count = 0;
    [row col] = size(input_data);
    result = zeros(row, col);
    for c=1:col
        count = 0;
        row_index_value = [];
        
        for r=1:row
            if input_data(r, c) > 0
                count = count + 1;
                row_index_value = [row_index_value; [r input_data(r, c)]];
            end
        end
        
        if count > 1
            [v i] = min(abs(row_index_value(:, 2) - average_pixel));
            result(row_index_value(i, 1), c) = row_index_value(i, 2);
        elseif count == 1
            result(row_index_value(1, 1), c) = row_index_value(1, 2);
            pixel_count = pixel_count + 1;
            average_pixel = average_pixel + (row_index_value(1,1) - average_pixel) / pixel_count;
        end
    end
end
