function canny_all_images(dirname, dump)
    if nargin == 1
        dump = 0;
    end
    dirlisting = dir(dirname);
    dirIndex   = [dirlisting.isdir];
    files      = {dirlisting(~dirIndex).name};
    dump_dir   = sprintf('canny_dump_%s', datestr(now, 30));
    if dump == 1, mkdir(dump_dir); end
    for i=1:length(files)
        filename = sprintf('%s/%s', dirname, files{i});
        im = dicomread(filename);
        [folder, name, ext] = fileparts(filename);
        im_edge = edge(im, 'canny', [0.02, 0.04]);
        if dump == 1
            imwrite(im_edge, sprintf('%s/%s.%s', dump_dir, name, 'png'));
        end
    end
end
