prev_boundaries = [91, 1, 5, 397, 1, 5];
im_data = get_im_data('../../data/nov_18_test_2/', 83);
regions = get_surface_regions(im_data, tank_surfaces);
[left right next_boundaries] = find_surface_boundary(regions.S3, prev_boundaries, 1, 'test')