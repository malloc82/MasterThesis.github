function marked_image = mark_image(image_data, pixels, plot_msg)
    max_val = 255;
    for i=1:length(pixels)
        group = pixels{i};
        [row col] = size(group);
        if length(group) == row
            for r=1:row
                index = group(r, :); 
                image_data(index(1), index(2)) = max_val;
            end
        else
            for c=1:col
                index = group(:, c);
                image_data(index(1), index(2)) = max_val;
            end
        end
    end

    if nargin > 2
        newfigure(sprintf('marked image : %s', plot_msg));
        imshow(image_data, []);
    end 
    marked_image = image_data;
end