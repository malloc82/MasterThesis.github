function println_vector(msg, vector, newline)
    if nargin < 3, newline = 0; end 
    [row col] = size(vector);
    if row == 1 || col == 1
        fprintf('%s = [', msg);
        for i=1:length(vector)-1
            fprintf('%.3f, ', vector(i))
        end
        if newline == 1
            fprintf('%.3f]\n', vector(end));
        else 
            fprintf('%.3f], ', vector(end));
        end 
    else 
        error('println_vector can only print 1-D vector, it cannot print matrix');
    end 
end
