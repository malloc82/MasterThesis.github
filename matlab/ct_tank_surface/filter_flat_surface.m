function S_out = filter_flat_surface(S_in)
    mk = [S_in(:, 2) ones(length(S_in), 1)] \ S_in(:, 1);
    S_out = S_in(abs(mk(1) * S_in(:, 2) + mk(2) - S_in(:, 1)) <= 1, :); 
end
