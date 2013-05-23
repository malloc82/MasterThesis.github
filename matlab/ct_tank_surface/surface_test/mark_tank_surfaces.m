function mark_tank_surfaces(filename)
    addpath('../');
    im = dicomread(filename);
    tank_surfaces = locate_surfaces(im);
    
    % mark middle column
    im(:, tank_surfaces.sample_column) = 255;
    
    % mark surfaces
    left  = tank_surfaces.sample_column-10;
    right = tank_surfaces.sample_column+10;
    im(tank_surfaces.exterior_outside_mid, left:right) = 255;
    im(tank_surfaces.exterior_inside_mid,  left:right) = 255;
    im(tank_surfaces.inferior_outside_mid, left:right) = 255;
    im(tank_surfaces.inferior_inside_mid,  left:right) = 255;
    
    % mark region
    im(tank_surfaces.exterior_outside_upper, :) = 255;
    im(tank_surfaces.exterior_outside_lower, :) = 255;
    
    im(tank_surfaces.exterior_inside_upper, :) = 255;
    im(tank_surfaces.exterior_inside_lower, :) = 255;
    
    im(tank_surfaces.inferior_outside_upper, :) = 255;
    im(tank_surfaces.inferior_outside_lower, :) = 255;

    im(tank_surfaces.inferior_inside_upper, :) = 255;
    im(tank_surfaces.inferior_inside_lower, :) = 255;

    [folder, name, ext] = fileparts(filename);
    newfigure(sprintf('marked surfaces: %s.%s', name, ext));
    imshow(im, []);
end
