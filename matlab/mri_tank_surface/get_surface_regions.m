function surfaces = get_surface_regions(im_data, tank_surfaces, label)
    surfaces = struct();

    S1_up   = tank_surfaces.exterior_outside_upper;
    S1_down = tank_surfaces.exterior_outside_lower;
    
    S2_up   = tank_surfaces.exterior_inside_upper;
    S2_down = tank_surfaces.exterior_inside_lower;
    
    S3_up   = tank_surfaces.inferior_outside_upper;
    S3_down = tank_surfaces.inferior_outside_lower;
    
    S4_up   = tank_surfaces.inferior_inside_upper;
    S4_down = tank_surfaces.inferior_inside_lower;

    if nargin == 2 || strcmp(label, 'all') || strcmp(label, 'ALL') || strcmp(label, 'All')
        surfaces.S1 = im_data(S1_up:S1_down, :);
        surfaces.S2 = im_data(S2_up:S2_down, :);
        surfaces.S3 = im_data(S3_up:S3_down, :);
        surfaces.S4 = im_data(S4_up:S4_down, :);
    elseif strcmp(label, 's1') || strcmp(label, 'S1')
        surfaces.S1 = im_data(S1_up:S1_down, :);
    elseif strcmp(label, 's2') || strcmp(label, 'S2')
        surfaces.S2 = im_data(S2_up:S2_down, :);
    elseif strcmp(label, 's3') || strcmp(label, 'S3')
        surfaces.S3 = im_data(S3_up:S3_down, :);
    elseif strcmp(label, 's4') || strcmp(label, 'S4')
        surfaces.S4 = im_data(S4_up:S4_down, :);
    else 
        error('Unrecognized label');
    end 
end
