function show_surface_regions(image_data, tank_surfaces)
    S1_up   = tank_surfaces.exterior_outside_upper;
    S1_down = tank_surfaces.exterior_outside_lower;
    
    S2_up   = tank_surfaces.exterior_inside_upper;
    S2_down = tank_surfaces.exterior_inside_lower;
    
    S3_up   = tank_surfaces.inferior_outside_upper;
    S3_down = tank_surfaces.inferior_outside_lower;
    
    S4_up   = tank_surfaces.inferior_inside_upper;
    S4_down = tank_surfaces.inferior_inside_lower;
    
    
    newfigure('exterior outside surface');
    imshow(image_data(S1_up:S1_down, :), []);

    newfigure('exterior inside  surface');
    imshow(image_data(S2_up:S2_down, :), []);

    newfigure('inferior outside surface');
    imshow(image_data(S3_up:S3_down, :), []);

    newfigure('inferior inside  surface');
    imshow(image_data(S4_up:S4_down, :), []);
    
end
