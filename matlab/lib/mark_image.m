function mark_image(image_data, pixels, string)
    max_val = 1024;
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
    
    if nargin == 3 && ~strcmp(string, '')
        newfigure(string)
    else 
        newfigure('marked image');
    end
    imshow(image_data, []);
end