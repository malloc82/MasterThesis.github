function edge_points = surface_edge(region, boundary, surface_label, plot_msg)
    % newfigure('original')
    % imshow(region, []);
    
    % Local Constants
    upper_surface = 0;
    lower_surface = 1;
    top_surface   = 2; % for removing robber paddings
    
    
    blurred_region = blur_image(region);
    left  = boundary(1);
    right = boundary(2);
    [row col] = size(region);

    gaussFilter5 = gausswin(5)';
    gaussFilter5 = gaussFilter5 / sum(gaussFilter5);    
    
    % newfigure('blurred');
    % imshow(blurred_region, []);
    
    function edge_point = locate_edge_point(column, orientation, display_range)
        data_points = zeros([1 row]);
        for i=1:row
            % NOTE: 3 worked ok, trying out 2.
            % data_points(i) = mean(blurred_region(i, (column-3):(column+3)));
            data_points(i) = mean(blurred_region(i, (column-2):(column+2)));
        end 
                
        data_smooth = conv(data_points, gaussFilter5);
        data_smooth = data_smooth(3:end-2);
        
        if orientation == upper_surface
            data_gradient = conv([1 0 -1], data_smooth);
            data_gradient = data_gradient(2:end-1);
        elseif orientation == lower_surface
            data_gradient = conv([-1 0 1], data_smooth);
            data_gradient = data_gradient(2:end-1);
        else
        end 

        [maxpeaks minpeaks] = peakdet(data_gradient, 10);
        
        if isempty(maxpeaks)
            edge_point = [];
        else 
            [v i] = max(maxpeaks(:, 2));
            edge_point = maxpeaks(i, 1);
        end

        %% ========== debug start ==========
        if nargin > 2 && column >= display_range(1) && column < display_range(2)
            newfigure(sprintf('histogram for column %d', column));
            plot((1:row), data_points, 'b', (1:row), data_gradient, 'r');
            if ~isempty(edge_point)
                fprintf('column %d : edge_point = %d \n', column, edge_point);
            end
        end
        % ----------------------------------
    end
    
    function [edge_points, edge_gradient] = process_peaks(edge_points, edge_gradient, peaks)
        for i=1:length(peaks)
            for j=peaks(i):length(edge_gradient)
                if edge_gradient(j) ~= 0 && edge_points(j, 1) ~= -1
                    edge_points(j, 1) = -1;
                else 
                    break
                end 
            end 
            for j=peaks(i)-1:-1:1
                if edge_gradient(j) ~= 0 && edge_points(j, 1) ~= -1
                    edge_points(j, 1) = -1;
                else 
                    break
                end 
            end 
        end 
    end 

    function filtered_edge = rempve_peaks(edge_points)
        while 1
            edge_gradient = conv([-1 0 1], edge_points(:, 1));
            edge_gradient = edge_gradient(2:end-1);
            % [(1:length(edge_gradient))' edge_gradient]
        
            [maxpeaks minpeaks] = peakdet(edge_gradient, 2);
            if isempty(maxpeaks) && isempty(minpeaks), break; end
            if ~isempty(maxpeaks)
                [edge_points edge_gradient] = process_peaks(edge_points, edge_gradient, maxpeaks(:, 1));
            end 
            if ~isempty(minpeaks)
                [edge_points edge_gradient] = process_peaks(edge_points, edge_gradient, minpeaks(:, 1));
            end 
            edge_points = edge_points(edge_points(:, 1) ~= -1, :);
        end 
        filtered_edge = edge_points;
    end 

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
            elseif edge_gradient(i) <= -1 || edge_gradient(i) >= 1
                if tracker_index == 0
                    tracker_index = 1;
                    tracker(1)    = 1;
                elseif tracker_index == 2
                    if sign(edge_gradient(i-tracker(2)-1)) == sign(edge_gradient(i))
                        Tracker = [1 0 0];
                        tracker_index = 1;
                    else 
                        tracker_index = 3;
                        tracker(3) = tracker(3) + 1;
                    end
                elseif edge_gradient(i-1) ~= 0 && sign(edge_gradient(i-1)) ~= sign(edge_gradient(i))
                    if tracker_index == 1
                        tracker_index = 3;
                        tracker(3)    = 1;
                    elseif tracker_index == 3
                        tracker_index = 5;
                    end 
                else 
                    tracker(tracker_index) = tracker(tracker_index) + 1;
                end 
            end 
            if tracker_index >= 4
                if tracker(1) <= 4 && tracker(2) <= 3 && tracker(3) <= 4
                    % fprintf('i = %d : [%d %d %d]\n', i, tracker(1), tracker(2), tracker(3));
                    len = sum(tracker);
                    edge_points(i-len:i-1, 1) = edge_points(i, 1) * ones(len, 1);
                    if tracker_index == 4
                        tracker = [0 0 0]; % reset tracker
                        tracker_index = 0; % reset index;
                    elseif tracker_index == 5
                        tracker = [1 0 0]; % reset tracker from tracker(1)
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
        filtered_edge = edge_points;
    end

    function plot_data_and_gradients(data_points, plot_msg)
        data_gradient = conv([-1 0 1], data_points(:, 1));
        data_gradient = data_gradient(2:end-1);
        [maxpeaks minpeaks] = peakdet(data_gradient, 2);
        newfigure(plot_msg)
        plot((1:length(data_points)), data_points(:, 1), 'b', ...
             (1:length(data_points)), data_gradient,     'r');    
    end    
    
    edge_points = [];
    
    if nargin <= 2 || strcmp(surface_label, 'S1') || strcmp(surface_label, 's1')
    end 
    if nargin <= 2 || strcmp(surface_label, 'S2') || strcmp(surface_label, 's2')
        for c=left:right
            p = locate_edge_point(c, lower_surface);
            if ~isempty(p), edge_points = [edge_points; [p, c]]; end
        end
    end 
    if nargin <= 2 || strcmp(surface_label, 'S3') || strcmp(surface_label, 's3')
        for c=left:right
            p = locate_edge_point(c, upper_surface);
            if ~isempty(p), edge_points = [edge_points; [p, c]]; end
        end
    end 
    if nargin <= 2 || strcmp(surface_label, 'S4') || strcmp(surface_label, 's4')
        for c=left:right
            p = locate_edge_point(c, lower_surface);
            if ~isempty(p), edge_points = [edge_points; [p, c]]; end
        end
    end 
    % mark_image(region, {edge_points}, 'raw edge');
    
    edge_points = remove_short_edges(edge_points, 'col', 8);
    edge_points = remove_short_bumps(edge_points);
    % plot_data_and_gradients(edge_points, 'after removing short bumps');

    smooth_edge = conv(edge_points(:, 1), gaussFilter5);
    edge_points(:, 1) = int32(round(smooth_edge(3:end-2)));
    
    % mark_image(region, {edge_points}, 'filtered edge');
    
    % mark_image(region, {edge_points(2:end-1, :)}, 'smoothed edge');
    
    % mark_image(region, {edge_points}, 'before remove bumps');
    % plot_data_and_gradients(edge_points, 'edge plot before removing bumps');

    edge_points = rempve_peaks(edge_points);
    edge_points = remove_short_bumps(edge_points);
    edge_points = remove_short_edges(edge_points, 'col', 5);
    
    % smooth_edge = conv(edge_points(:, 1), gaussFilter5);
    
    % mark_image(region, {edge_points(2:end-1, :)}, 'processed edge');
        
    % plot_data_and_gradients(edge_points, 'edge and it''s gradient plot');
    
    % plot_data_and_gradients(edge_points, 'edge after removing bumps');
    
    % max(edge_points(:, 1))
    % min(edge_points(:, 1))

    if nargin > 3
        mark_image(region, {edge_points(2:end-1, :)}, sprintf('final edge : %s', plot_msg));
        plot_data_and_gradients(edge_points, sprintf('final edge gradient plot : %s', plot_msg));
    end 
end
