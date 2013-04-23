function result = smooth_data(input, mask)
    if nargin == 1
        mask = [-1 0 1];
        mask_width = 1;
    else
        mask_width = int32(length(mask)/2);
    end
end
