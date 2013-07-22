% initial setup
sagittal_set = getAllFiles('../../../data/nov_18_test_6_sagittal/');
coronal_set = getAllFiles('../../../data/nov_18_test_6_coronal/');
mri_sagittal_sample112_avg = get_im_data(sagittal_set, [111, 112, 113]);
mri_surfaces_locations = locate_surfaces(mri_sagittal_sample112_avg, '');

