function mark_columns(index, columns, msg)
    im_data = dicomread(sprintf('../../data/nov_18_test_2/20121118_%0.3d.dcm', index));
    for i=1:length(columns)
        im_data(:, columns(i)) = 255;
    end
    if nargin < 3
        newfigure('image with marked columns');
    else 
        newfigure(strcat('Marked columns: ', msg));
    end
    imshow(im_data, []);
end









