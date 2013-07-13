function im_data = get_im_data(image_set, index)
    addpath(sprintf('%s/%s', pwd, '../../lib'));
    im_data = dicomread(image_set{index(1)});
    count = length(index);
    if count > 1
        for i=2:length(index)
            im_data = im_data + dicomread(image_set{index(i)});
        end 
        im_data = im_data / count;
    end 
end
