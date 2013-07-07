function marked_image = image_mark_rows(image_data, rows, plot_data, msg)
    marked_value = 255;
    marked_image = image_data;
    for i=1:length(rows)
        marked_image(rows(i), :) = marked_value;
    end 
    
    if nargin > 2 && plot_data == 1
        if nargin > 3
            newfigure(msg)
        else 
            newfigure('image with marked rows')
        end 
        imshow(marked_image, []);
    end 
end
