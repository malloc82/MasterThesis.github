function [ax by cz d] = plane_estimation(S_in)
% ax X + by Y + cz Z + d = 0
% Ax = b 
% (-ax/by) X + (-cz/by) Z + (-d/by) = Y
    
    b = -S_in(:, 2);
    A = [ S_in(:, 1) S_in(:, 3) ones(length(S_in), 1)];
    x = A\b;
    
    ax = x(1);
    by = 1;
    cz = x(2);
    d  = x(3);
end
