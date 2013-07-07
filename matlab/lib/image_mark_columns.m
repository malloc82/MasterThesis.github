function marked_image = image_mark_columns(image_data, columns, plot_data, msg)
    marked_value = 255;
    marked_image = image_data;
    for i=1:length(columns)
        marked_image(:, columns(i)) = marked_value;
    end 
    
    if nargin > 2 && plot_data == 1
        if nargin > 3
            newfigure(msg)
        else 
            newfigure('image with marked columns')
        end 
        imshow(marked_image, []);
    end 
end
