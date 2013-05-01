function filter_tank(filename, threshold, dump, dump_dir)
    if nargin < 3, dump = 0; end
    [folder, name, ext] = fileparts(filename);
    canny_thresholds = [0.02, 0.04];
    im = dicomread(filename);

    filtered_im      = threshold_filter(im, threshold);
    filtered_im_edge = edge(filtered_im, 'canny', canny_thresholds);
    original_edge    = edge(im, 'canny', canny_thresholds);
    
    if dump == 1        
        dicomwrite(filtered_im, sprintf('%s/%s_filtered.dcm', dump_dir, name));
        imwrite(filtered_im_edge, sprintf('%s/%s_filtered_edge.png', dump_dir, name));
        imwrite(original_edge, sprintf('%s/%s_edge.png', dump_dir, name));
    else 
        newfigure('filtered_tank');
        imshow(filtered_im, []);
        
        newfigure('filtered tank canny');
        imshow(filtered_im_edge);
        
        newfigure('original image canny');
        imshow(original_edge);
    end
end
