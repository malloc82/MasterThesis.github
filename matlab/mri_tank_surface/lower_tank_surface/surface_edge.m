function edge_points = surface_edge(region, boundary)
    % newfigure('original')
    % imshow(region, []);
    
    blurred_region = blur_image(region);
    left  = boundary(1);
    right = boundary(2);
    [row col] = size(region);

    gaussFilter5 = gausswin(5)';
    gaussFilter5 = gaussFilter5 / sum(gaussFilter5);

    gaussFilter7 = gausswin(7)';
    gaussFilter7 = gaussFilter7 / sum(gaussFilter7);
    
    
    % newfigure('blurred');
    % imshow(blurred_region, []);
    
    function edge_point = locate_edge_point_S4(column)
        data_points = zeros([1 row]);
        for i=1:row
            data_points(i) = mean(blurred_region(i, (column-3):(column+3)));
        end 
                
        data_smooth = conv(data_points, gaussFilter5);
        data_smooth = data_smooth(3:end-2);
        
        data_gradient = conv([-1 0 1], data_smooth);
        data_gradient = data_gradient(2:end-1);

        % gradient_smooth = conv(data_gradient, gaussFilter7);
        % gradient_smooth = gradient_smooth(4:end-3);
        
        [maxpeaks minpeaks] = peakdet(data_gradient, 10);

        % newfigure(sprintf('histogram for column %d', column));
        % plot((1:row), data_points, 'b', ...
        %      (1:row), data_gradient, 'r');
        if ~isempty(maxpeaks), edge_point = max(maxpeaks(:, 1)); else edge_point = []; end
    end
    edge_points = [];
    for c=left:right
        edge_points = [edge_points; [locate_edge_point_S4(c), c]];
    end
    edge_points   = remove_short_edges(edge_points, 'col', 8);
    edge_gradient = conv([-1 0 1], edge_points(:, 1));
    edge_gradient = edge_gradient(2:end-1);
    [maxpeaks minpeaks] = peakdet(edge_gradient, 2);

    if ~isempty(maxpeaks)
        [row col] = size(maxpeaks);
        for r=1:row
            edge_points(maxpeaks(r,1)-3:maxpeaks(r,1)+3, :)
        end
    end 

    if ~isempty(minpeaks)
        [row col] = size(minpeaks);
        for r=1:row
            edge_points(minpeaks(r,1)-3:minpeaks(r,1)+3, :)
        end
    end 
    
    marked_image = mark_image(region, {edge_points});
    newfigure('edge');
    imshow(marked_image, []);

    selected_edge = [edge_points(maxpeaks(:, 1), :); edge_points(minpeaks(:, 1), :)]
    image_mark_columns(marked_image, selected_edge(:, 2), '');
end
