function im_data = get_im_data(image_set_dir, index)
    addpath(sprintf('%s/%s', pwd, '../lib'));
    image_set = getAllFiles(image_set_dir);
    
    prev_sample  = dicomread(sprintf('%s/%s', image_set_dir, image_set{index-1}));
    sample       = dicomread(sprintf('%s/%s', image_set_dir, image_set{index}));
    next_sample  = dicomread(sprintf('%s/%s', image_set_dir, image_set{index+1}));
    
    im_data = prev_sample + sample + next_sample;
end
