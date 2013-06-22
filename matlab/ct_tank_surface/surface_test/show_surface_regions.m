function show_surface_regions(imagename, surface_locations, show_edge)
    addpath('../');
    if nargin <= 2
        show_edge = 0;
    end
    
    [S1 S2 S3 S4] = get_surface_data(imagename, surface_locations);
    
    im = dicomread(imagename);
    mark_image(im, {S1, S2, S3, S4}, 'marked surface');
    
    % [folder, name, ext] = fileparts(imagename);
    % im = dicomread(imagename);

    % S1 = surface_locations.exterior_outside_upper;
    % S2 = surface_locations.exterior_outside_lower;
    
    % S3 = surface_locations.exterior_inside_upper;
    % S4 = surface_locations.exterior_inside_lower;
    
    % S5 = surface_locations.inferior_outside_upper;
    % S6 = surface_locations.inferior_outside_lower;
    
    % S7 = surface_locations.inferior_inside_upper;
    % S8 = surface_locations.inferior_inside_lower;
    
    % surface1 = im(S1:S2, :);
    % surface2 = im(S3:S4, :);
    % surface3 = im(S5:S6, :);
    % surface4 = im(S7:S8, :);
    
    % newfigure(sprintf('%s.%s : surface 1', name, ext));
    % imshow(surface1, []);
    % newfigure(sprintf('%s.%s : surface 2', name, ext));
    % imshow(surface2, []);    
    % newfigure(sprintf('%s.%s : surface 3', name, ext));
    % imshow(surface3, []);
    % newfigure(sprintf('%s.%s : surface 4', name, ext));
    % imshow(surface4, []);
    
    % if show_edge ~= 0
        
    % end
end
