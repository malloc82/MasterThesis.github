function [left, right, boundary_info] = find_surface_boundary(surface_region, prev_boundaries, plot_data, msg)
% prev_boundaries format:
%    [left left_direction left_range right right_direction right_range]
% if no left or right is found increment pixel_range for the 
% slice after this.
% 
% if pixel_range < 0, it means left and right boundaries have
% already intercepted each other, and current region has nothing to
% look for.
    
    min_delta = 5; 
    
    L       = 1;
    L_diff  = 2;
    L_range = 3;
    R       = 4;
    R_diff  = 5;
    R_range = 6;
    
    if ~isempty(prev_boundaries) && ...
            prev_boundaries(L) + prev_boundaries(L_range) >= prev_boundaries(R) - prev_boundaries(R_range) - 10
        % note: 10 is a safe distance to the edge
        left  = [];
        right = [];
        boundary_info = prev_boundaries;
        fprintf(' prev_boundaries = [%d, %d, %d, %d, %d, %d], ', ...
                prev_boundaries(L), prev_boundaries(L_diff), prev_boundaries(L_range), ...
                prev_boundaries(R), prev_boundaries(R_diff), prev_boundaries(R_range));
        fprintf('No surface, out of range');
        return
    else 
        if ~isempty(prev_boundaries)
        fprintf(' prev_boundaries = [%d, %d, %d, %d, %d, %d], ', ...
                prev_boundaries(L), prev_boundaries(L_diff), prev_boundaries(L_range), ...
                prev_boundaries(R), prev_boundaries(R_diff), prev_boundaries(R_range));
        else 
            fprintf(' prev_boundaries is empty, ')
        end 
    end 
    
    cutoff = 5;  % ?
    column_sums = zeros(1, length(surface_region));
    for i=1:length(column_sums)
        column_sums(i) = sum(surface_region(:, i));
    end
    gradient_data = smooth_gradient(column_sums);
    if nargin >= 2 && plot_data == 1
        if nargin == 3
            newfigure(sprintf('surface data2: %s', msg));
        else 
            newfigure('surface data')
        end
        plot((1:length(gradient_data)), column_sums, 'b', ...
             (1:length(gradient_data)), gradient_data, 'r');
    end
    [maxpeaks, minpeaks] = peakdet(gradient_data, 250);
    
    % maxpeaks(maxpeaks(:, 2) < 1000 & maxpeaks(:, 2) > 250, :);

    if isempty(prev_boundaries)
        boundary_info = [0 0 0 0 0 0];
    else 
        boundary_info = prev_boundaries;
    end 
    
    % boundary threshold
    right_candidates = maxpeaks(maxpeaks(:, 2) <  1000 & maxpeaks(:, 2) >  200, 1);
    if ~isempty(prev_boundaries)
        diffs = right_candidates - prev_boundaries(R);
        if prev_boundaries(R_range) > min_delta
            diff_index = abs(diffs) <= prev_boundaries(R_range) & sign(diffs) == sign(prev_boundaries(R_diff));
        else 
            diff_index = abs(diffs) <= prev_boundaries(R_range);
        end        
        if isempty(diffs(diff_index))
            if prev_boundaries(R_range) <= min_delta
                right = prev_boundaries(R) + prev_boundaries(R_diff);
                boundary_info(R)       = right;
                boundary_info(R_diff)  = prev_boundaries(R_diff);
                boundary_info(R_range) = prev_boundaries(R_range) + min_delta;
            else 
                right = [];
                left  = [];
                boundary_info(R_range) = prev_boundaries(R_range) + min_delta;
                fprintf('Cannot determine right boundary1, ');
                return
            end 
        else
            right = right_candidates(diff_index);
            boundary_info(R)       = right;
            diff = right - prev_boundaries(R);
            if diff == 0
                boundary_info(R_diff) = sign(prev_boundaries(R_diff));
            else 
                boundary_info(R_diff) = diff;
            end 
            boundary_info(R_range) = min_delta;
        end
    else 
        [c i] = max(column_sums(right_candidates));
        right = right_candidates(i);
        if isempty(right) || column_sums(right) < 0
            right = [];
            left  = [];
            boundary_info = [];
            fprintf('Cannot determine right boundary2, ');
            return
        end 
        boundary_info(R)       = right;
        boundary_info(R_diff)  = 0;
        boundary_info(R_range) = min_delta;
    end 

    left_candidates = minpeaks(minpeaks(:, 2) > -1000 & minpeaks(:, 2) < -200, 1);
    if ~isempty(prev_boundaries)
        diffs = left_candidates - prev_boundaries(L);
        if prev_boundaries(L_range) > min_delta
            diff_index = abs(diffs) <= prev_boundaries(L_range) & sign(diffs) == sign(prev_boundaries(L_diff));
        else 
            diff_index = abs(diffs) <= prev_boundaries(L_range);
        end
        if isempty(diffs(diff_index))
            if prev_boundaries(L_range) <= min_delta
                left = prev_boundaries(L) + prev_boundaries(L_diff);
                boundary_info(L)       = left;
                boundary_info(L_diff)  = prev_boundaries(L_diff);
                boundary_info(L_range) = prev_boundaries(L_range) + min_delta;
            else 
                right = [];
                left  = [];
                boundary_info(L_range) = prev_boundaries(L_range) + min_delta;
                fprintf('Cannot determine left boundary1, ');
                return
            end 
        else 
            left = left_candidates(diff_index);
            boundary_info(L)       = left_candidates(diff_index);
            diff = left - prev_boundaries(L);
            if diff == 0
                boundary_info(L_diff) = sign(prev_boundaries(L_diff));
            else 
                boundary_info(L_diff) = diff;
            end 
            boundary_info(L_range) = min_delta;
        end 
    else 
        [c i] = max(column_sums(left_candidates));
        left = left_candidates(i);
        if isempty(left) || column_sums(left) < 0
            right = [];
            left  = [];
            boundary_info = [];
            fprintf('Cannot determine left boundary2, ');
            return
        end 
        boundary_info(L)       = left;
        boundary_info(L_diff)  = 0;
        boundary_info(L_range) = min_delta;
    end     
    
    if nargin > 1 && plot_data == 1
        left_return  = left
        right_return = right
    end
end
