function [upper_edge, lower_edge] = lower_tank_surface_edge(image_data, column)
    if upper_boundary < 0 || lower_boundary < 0
        display('calling get_midtank_boundary ...');
        [upper_boundary, lower_boundary] = get_midtank_boundary(image_data(:, col/2));
    else
        display('get_midtank_boundary called already ...');
    end
    % newfigure('Lower');
    % imshow(image_data(lower_boundary:end, :), []);
    [upper_edge, lower_edge] = find_edges_region(blur_image(image_data(lower_boundary:end, :)), column);
    lower_tank_edges = [lower_tank_edges {[column, upper_edge, lower_edge]}];
end
