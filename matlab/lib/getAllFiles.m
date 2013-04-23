function files = getAllFiles(dirname)
    if strcmp(dirname, '')
        fprintf('Cannot open ''''\n');
        files = {};
        return; 
    end
    dirlisting = dir(dirname);
    dirIndex   = [dirlisting.isdir];
    files      = {dirlisting(~dirIndex).name}';
    for i=1:length(files)
        files{i} = sprintf('%s/%s', dirname, files{i});
    end
end