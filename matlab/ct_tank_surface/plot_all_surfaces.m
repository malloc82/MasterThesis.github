function plot_all_surfaces(S1, S2, S3, S4)
    newfigure('Tank surfaces')
    hold on
    grid on
    if ~isempty(S1), scatter3(S1(:, 1), S1(:, 2), S1(:, 3), 'b'); end
    if ~isempty(S2), scatter3(S2(:, 1), S2(:, 2), S2(:, 3), 'r'); end
    if ~isempty(S3), scatter3(S3(:, 1), S3(:, 2), S3(:, 3), 'g'); end
    if ~isempty(S4), scatter3(S4(:, 1), S4(:, 2), S4(:, 3), 'k'); end
    hold off
end
