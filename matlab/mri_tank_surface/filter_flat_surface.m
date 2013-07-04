function S_out = filter_flat_surface(S_in, image_length)
    mk = [S_in(:, 2) ones(length(S_in), 1)] \ S_in(:, 1);

    pixels = cell(image_length);
    for i=1:length(S_in)
        pixels{S_in(i, 2)} = [pixels{S_in(i, 2)} S_in(i, 1)];
    end

    S_out = [];
    for c=1:length(pixels)
        if ~isempty(pixels{c})
            [d i] = min(abs(mk(1) * c + mk(2) - pixels{c}));
            if d <= 1
                S_out = [S_out; [pixels{c}(i) c]];
            end
        end
    end
end
