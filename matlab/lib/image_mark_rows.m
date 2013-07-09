function marked_image = image_mark_rows(image_data, rows, plot_msg)
    marked_value = 255;
    marked_image = image_data;
    for i=1:length(rows)
        marked_image(rows(i), :) = marked_value;
    end 
    
    if nargin > 2
        newfigure(sprintf('image with marked rows : %s', plot_msg));
        imshow(marked_image, []);
    end 
end
