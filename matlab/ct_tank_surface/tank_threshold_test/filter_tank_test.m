function filter_tank_test(dirname, dump_dir)
    dirlisting = dir(dirname);
    dirIndex   = [dirlisting.isdir];
    files      = {dirlisting(~dirIndex).name};
    
    dump_dir = sprintf('%s_%s', dump_dir, datestr(now, 30));
    if ~exist(dump_dir, 'dir')
        mkdir(dump_dir);
    end
    
    for i=1:length(files)
        fprintf('%0.3d..', i);
        if rem(i, 30) == 0, fprintf('\n'); end
        filename = sprintf('%s/%s', dirname, files{i});
        filter_tank(filename, 42, 1, dump_dir);
    end
    fprintf('done\n');
end
