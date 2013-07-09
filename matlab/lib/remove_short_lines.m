function result = remove_short_lines(im_data, min_length)
    if nargin == 1
        min_length = 15;
    end
    [row, col] = size(im_data);
    result = zeros(row, col);

    function verify_edge(r, c, value)
        edge_pixels = {[r c im_data(r, c)]};
        edge_length = 1;
        trace       = {};
        im_data(r, c)  = 0;
        
        first_round = 1;
        while first_round || length(trace) > 0
            first_round = 0;
            if length(trace) > 0
                pixel = trace{end};
                r = pixel(1);
                c = pixel(2);
                trace(end) = [];

            end
            % im_data(r, c) = 0;
            for i=r-1:r+1
                for j=c-1:c+1
                    if (i ~= r || j ~= c) && i >= 1 && i <= row && j >= 1 && j <= col
                        if im_data(i, j) > 0
                            edge_pixels = [edge_pixels [i j im_data(i, j)]];
                            edge_length = edge_length + 1;
                            trace = [trace [i j]];
                            im_data(i, j) = 0;
                        end
                    end
                end
            end
        end
        
        if edge_length < min_length
            return
        else 
            % restore original values
            for i=1:length(edge_pixels)
                pixel = edge_pixels{i};
                result(pixel(1), pixel(2)) = pixel(3);
            end
        end
    end
    
    for r=1:row
        for c=1:col
            if r >= 1 && r <= row && c >= 1 && c <= col
                if im_data(r, c) > 0
                    verify_edge(r, c, im_data(r, c));
                end
            end
        end
    end
    % imshow(result, []);
end
