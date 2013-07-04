tank_surfaces = locate_surfaces(get_im_data('../../data/nov_18_test_2/', 112));
for i=112:-1:109
    boundary_test(tank_surfaces, i);
end