function thresholds = tank_threshold_test(dirname, plot_opt)
    if nargin == 1
        plot_opt = 0;
    end
    dirlisting = dir(dirname);
    dirIndex   = [dirlisting.isdir];
    files      = {dirlisting(~dirIndex).name};
    thresholds = [];
    for i=1:length(files)
        filename = sprintf('%s/%s', dirname, files{i});
        threshold_val = tank_threshold(filename);
        thresholds = [thresholds; threshold_val];
    end
    if plot_optx == 1
        plot((1:length(thresholds)), thresholds);
    end
end
