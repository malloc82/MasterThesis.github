function plot_all_surfaces(S1, S2, S3, S4)
    hold on
    grid on
    % scatter3(S1(:, 1), S1(:, 2), S1(:, 3), 'b');
    % scatter3(S2(:, 1), S2(:, 2), S2(:, 3), 'r');
    % scatter3(S3(:, 1), S3(:, 2), S3(:, 3), 'g');
    scatter3(S4(:, 1), S4(:, 2), S4(:, 3), 'k');
    hold off
end
