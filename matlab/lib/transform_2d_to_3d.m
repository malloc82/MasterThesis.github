function coord_3d = transform_2d_to_3d(coord_2d, position, orientation, spacing)
% mask is [3, 1] vector, e.g. [1 0 1]
    if isempty(coord_2d)
        coord_3d = [];
    else 
        coord_3d = dicom_coordinate(S1_2d, position, orientation, spacing);
    end 
    % coord_3d = zeros(length(coord_2d), 3);
    % if mask(1) == 1
    %     coord_3d(:, 1)   = coord_2d(:, 1);
    %     if mask(2) == 1
    %         coord_3d(:, 2) = coord_2d(:, 2);
    %     elseif mask(3) == 1
    %         coord_3d(:, 3) = coord_2d(:, 2);
    %     end
    % else
    %     coord_3d(:, 2:3) = coord_2d;
    % end
end
