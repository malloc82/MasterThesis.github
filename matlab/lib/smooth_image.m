function new_image = smooth_image(image_data, mask)
    if nargin == 1
        mask_row = 5;
        mask_col = 5;
        mask = fspecial('gaussian', [mask_row mask_col], 1.4);
    else
        [mask_row mask_col] = size(mask);
    end
    
    [mask_row, mask_col] = size(mask);
    row_width = idivide(int32(mask_row), 2);
    col_width = idivide(int32(mask_col), 2);
    
    new_image = conv2(mask, double(image_data));
    new_image = new_image(row_width+1:end-row_width, col_width+1:end-col_width);
end
