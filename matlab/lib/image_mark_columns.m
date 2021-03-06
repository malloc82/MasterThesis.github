function marked_image = image_mark_columns(image_data, columns, plot_msg)
    marked_value = 255;
    marked_image = image_data;
    for i=1:length(columns)
        marked_image(:, columns(i)) = marked_value;
    end 
    
    if nargin > 2
        newfigure(sprintf('image with marked columns : %s', plot_msg));
        imshow(marked_image, []);
    end 
end
