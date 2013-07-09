function edge_points = surface_edge(region, boundary)
    % newfigure('original')
    % imshow(region, []);
    
    blurred_region = blur_image(region);
    left  = boundary(1);
    right = boundary(2);
    [row col] = size(region);

    gaussFilter5 = gausswin(5)';
    gaussFilter5 = gaussFilter5 / sum(gaussFilter5);    
    
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
    
    function [edge_points, edge_gradient] = process_peaks(edge_points, edge_gradient, peaks) % maxpeaks(:, 1)
        for i=1:length(peaks)
            for j=peaks(i):length(edge_gradient)
                % if sign(edge_gradient(j)) == sign(edge_gradient(peaks(i))) && ...
                %         edge_points(j, 1) ~= -1
                if edge_gradient(j) ~= 0 && edge_points(j, 1) ~= -1
                    edge_points(j, 1) = -1;
                else 
                    break
                end 
            end 
            for j=peaks(i)-1:-1:1
                % if sign(edge_gradient(j)) == sign(edge_gradient(peaks(i))) && ...
                %         edge_points(j, 1) ~= -1
                if edge_gradient(j) ~= 0 && edge_points(j, 1) ~= -1
                    edge_points(j, 1) = -1;
                else 
                    break
                end 
            end 
        end 
    end 

    function filtered_edge = remove_bumps(edge_points)
        edge_gradient = conv([-1 0 1], edge_points(:, 1));
        edge_gradient = edge_gradient(2:end-1);
        [maxpeaks minpeaks] = peakdet(edge_gradient, 2);
        [edge_points edge_gradient] = process_peaks(edge_points, edge_gradient, maxpeaks(:, 1));
        [edge_points edge_gradient] = process_peaks(edge_points, edge_gradient, minpeaks(:, 1));
        filtered_edge = edge_points(edge_points(:, 1) ~= -1, :);
    end 
    
    
    edge_points = [];
    for c=left:right
        edge_points = [edge_points; [locate_edge_point_S4(c), c]];
    end
    % marked_image = mark_image(region, {edge_points});
    % newfigure('raw edge');
    % imshow(marked_image, []);

    
    edge_points  = remove_short_edges(edge_points, 'col', 8);
    % marked_image2 = mark_image(region, {edge_points});
    % newfigure('filtered edge');
    % imshow(marked_image2, []);
    
    smooth_edge = conv(edge_points(:, 1), gaussFilter5);
    edge_points(:, 1) = int32(round(smooth_edge(3:end-2)));
    % marked_image3 = mark_image(region, {edge_points(2:end-1, :)});
    % newfigure('smoothed edge');
    % imshow(marked_image3, []);

    edge_points = remove_bumps(edge_points);
    edge_points = remove_bumps(edge_points);
    edge_points = remove_short_edges(edge_points, 'col', 5);
    % smooth_edge = conv(edge_points(:, 1), gaussFilter5);
    
    % marked_image4 = mark_image(region, {edge_points(2:end-1, :)});
    % newfigure('processed edge');
    % imshow(marked_image4, []);
        
    % edge_gradient = conv([-1 0 1], edge_points(:, 1));
    % edge_gradient = edge_gradient(2:end-1);
    % [maxpeaks minpeaks] = peakdet(edge_gradient, 2);
    % newfigure('edge and it''s gradient plot')
    % plot((1:length(edge_points)), edge_points(:, 1), 'b', ...
    %      (1:length(edge_points)), edge_gradient,     'r');    

    function filtered_edge = remove_short_bumps(edge_points)
        edge_gradient = conv([-1 0 1], edge_points(:, 1));
        edge_gradient = edge_gradient(2:end-1);
        % [(1:length(edge_gradient))' edge_gradient]

        tracker = [0 0 0];
        tracker_index = 0;
        for i=2:length(edge_points(:, 1))-1
            if edge_gradient(i) == 0
                if tracker_index == 1 || tracker_index == 3
                    tracker_index = tracker_index + 1;
                end 
                if tracker_index == 2 
                    tracker(2) = tracker(2) + 1;
                    if tracker(2) >= 4
                        tracker = [0 0 0];
                        tracker_index = 0;
                    end 
                end
            elseif edge_gradient(i) == -1 || edge_gradient(i) == 1
                if tracker_index == 0
                    tracker_index = 1;
                    tracker(1) = tracker(1) + 1;
                elseif tracker_index == 2
                    if sign(edge_gradient(i-tracker(2)-1)) == edge_gradient(i)
                        tracker = [1 0 0];
                        tracker_index = 1;
                    else 
                        tracker_index = 3;
                        tracker(3) = tracker(3) + 1;
                    end
                elseif edge_gradient(i-1) ~= 0 && sign(edge_gradient(i-1)) ~= sign(edge_gradient(i))
                    if tracker_index == 1 
                        tracker_index = 3;
                        tracker(3) = tracker(3) + 1;
                    elseif tracker_index == 3
                        tracker_index = 5;
                    end 
                else 
                    tracker(tracker_index) = tracker(tracker_index) + 1;
                end 
            end 
            if tracker_index >= 4
                if tracker(1) <= 3 && tracker(2) <= 2 && tracker(3) <= 3
                    % fprintf('i = %d : [%d %d %d]\n', i, tracker(1), tracker(2), tracker(3));
                    len = sum(tracker);
                    edge_points(i-len:i-1, 1) = edge_points(i, 1) * ones(len, 1);
                    if tracker_index == 4
                        tracker = [0 0 0]; % reset tracker
                        tracker_index = 0; % reset index;
                    elseif tracker_index == 5
                        tracker = [1 0 0]; % reset tracker
                        tracker_index = 1;
                    end 
                else 
                    tracker = [tracker(3) 0 0];
                    if tracker_index == 4
                        tracker_index = 2;
                        tracker(tracker_index) = 1;
                    elseif tracker_index == 5
                        tracker_index = 3;
                        tracker(tracker_index) = 1;
                    end
                end 
            end 
        end 
        
        % for i=1:length(edge_points(:, 1))-4
        %     if edge_gradient(i) == 1
        %         if edge_gradient(i:i+2) == [1; -1; 0]
        %             edge_points(i:i+1, 1) = [edge_points(i+2, 1); edge_points(i+2, 1)]
        %             edge_gradient(i:i+1) = [0; 0];
        %         elseif edge_gradient(i:i+4) == [1; 1; -1; -1; 0]
        %             edge_points(i:i+3) = edge_points(i+4, 1) * ones(4, 1);
        %             edge_gradient(i:i+3) = zeros(4, 1);
        %         elseif edge_gradient(i:i+5) == [1; 1; 0; -1; -1; 0]
        %             edge_points(i:i+4) = edge_points(i+5, 1) * ones(5, 1);
        %             edge_gradient(i:i+4) = zeros(5, 1);                    
        %         end 
        %     elseif edge_gradient(i) == -1
        %         if edge_gradient(i:i+2) == [-1; 1; 0]
        %             edge_points(i:i+1, 1) = [edge_points(i+2, 1); edge_points(i+2, 1)]
        %             edge_gradient(i:i+1) = [0; 0];
        %         elseif edge_gradient(i:i+4) == [-1; -1; 1; 1; 0]
        %             edge_points(i:i+3) = edge_points(i+4, 1) * ones(4, 1);
        %             edge_gradient(i:i+3) = zeros(4, 1);
        %         elseif edge_gradient(i:i+5) == [-1; -1; 0; 1; 1; 0]
        %             edge_points(i:i+4) = edge_points(i+5, 1) * ones(5, 1);
        %             edge_gradient(i:i+4) = zeros(5, 1);                    
        %         end 
        %     end 
        % end 
        
        % filtered_edge = edge_points(edge_points(:, 1) ~= -1, :);
        filtered_edge = edge_points;
    end
    edge_points = remove_short_bumps(edge_points);
    marked_image5 = mark_image(region, {edge_points(2:end-1, :)});
    newfigure('edge removed 2 pixels bumps');
    imshow(marked_image5, []);

    % edge_gradient = conv([-1 0 1], edge_points(:, 1));
    % edge_gradient = edge_gradient(2:end-1);
    % [maxpeaks minpeaks] = peakdet(edge_gradient, 2);
    % newfigure('edge plot after removing bumps')
    % plot((1:length(edge_points)), edge_points(:, 1), 'b', ...
    %      (1:length(edge_points)), edge_gradient,     'r');    
    
    % max(edge_points(:, 1))
    % min(edge_points(:, 1))
end
