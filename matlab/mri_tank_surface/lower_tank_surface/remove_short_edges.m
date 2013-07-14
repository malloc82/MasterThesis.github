function filtered_edge = remove_short_edges(edge_data, orientation, min_length)
% edge_data : each row is a coordinate
    if nargin < 2
        min_length = 5;
    end
    [row, col] = size(edge_data);
    if strcmp(orientation, 'col') || strcmp(orientation, 'Col') || strcmp(orientation, 'COL')
        start = 1;
        edge_length = 1;
        for i=2:length(edge_data)
            if edge_data(i, 2)-1 ~= edge_data(i-1, 2) || abs(edge_data(i, 1) - edge_data(i-1, 1)) > 1
                if edge_length < min_length
                    edge_data(start:i-1, 1) = -1;
                    start = i;
                    edge_length = 1;
                else 
                    start = i;
                    edge_length = 1;
                end 
            else 
                edge_length = edge_length + 1;
            end 
        end 
        filtered_edge = edge_data(edge_data(:, 1) > 0, :);
    elseif strcmp(orientation, 'row') || strcmp(orientation, 'Row') || strcmp(orientation, 'ROW')
        % This case is not used
    else
        
    end 
end
