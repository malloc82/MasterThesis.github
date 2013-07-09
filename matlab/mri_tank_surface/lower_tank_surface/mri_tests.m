
edge_points;
edge_gradient = conv([-1 0 1], edge_points(:, 1));
edge_gradient = edge_gradient(2:end-1);

newfigure('edge and it''s gradient plot')
plot((1:length(edge_points)), edge_points(:, 1), 'b', ...
     (1:length(edge_points)), edge_gradient, 'r');