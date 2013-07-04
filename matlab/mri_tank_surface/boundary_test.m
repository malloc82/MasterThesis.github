function boundary_test(tank_surfaces, index)
    im_data = get_im_data('../../data/nov_18_test_2/', index);
    region = get_surface_regions(im_data, tank_surfaces);
    
    newfigure(sprintf('region : %0.3d', index));
    imshow(region.S2, []);
    
    [column_averages, maxpeak, minpeak] = boundary_histogram_test(region.S2, 1, int2str(index));
    maxpeak
    minpeak
end
