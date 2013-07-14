function blurred_image = blur_image(image_data)
    mask = fspecial('gaussian', [5, 5]);
    [mask_row, mask_col] = size(mask);
    % convdata = conv2d(input_data, mask);
    
    convdata = conv2(mask, double(image_data));
    blurred_image = convdata(3:end-2, 3:end-2);
end % blur_image
