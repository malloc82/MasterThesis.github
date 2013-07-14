function surfaces = get_surface_regions(im_data, tank_surfaces)
    surfaces = struct();

    surfaces.S1_up   = tank_surfaces.exterior_outside_upper;
    surfaces.S1_down = tank_surfaces.exterior_outside_lower;
    
    surfaces.S2_up   = tank_surfaces.exterior_inside_upper;
    surfaces.S2_down = tank_surfaces.exterior_inside_lower;
    
    surfaces.S3_up   = tank_surfaces.inferior_outside_upper;
    surfaces.S3_down = tank_surfaces.inferior_outside_lower;
    
    surfaces.S4_up   = tank_surfaces.inferior_inside_upper;
    surfaces.S4_down = tank_surfaces.inferior_inside_lower;

    surfaces.S1 = im_data(surfaces.S1_up:surfaces.S1_down, :);
    surfaces.S2 = im_data(surfaces.S2_up:surfaces.S2_down, :);
    surfaces.S3 = im_data(surfaces.S3_up:surfaces.S3_down, :);
    surfaces.S4 = im_data(surfaces.S4_up:surfaces.S4_down, :);
end
