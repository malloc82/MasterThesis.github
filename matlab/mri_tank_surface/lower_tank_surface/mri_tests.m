
[row, col] = size(region);
for r=1:row
    for c=1:col
        if region(r, c) > 120
            region(r, c) = 0;
        end 
    end 
end