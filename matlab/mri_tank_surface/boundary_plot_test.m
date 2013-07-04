function boundary_plot_test(im_data, tank_surfaces)
    S1_up   = tank_surfaces.exterior_outside_upper;
    S1_down = tank_surfaces.exterior_outside_lower;
    S1      = im_data(S1_up:S1_down, :);
    
    S2_up   = tank_surfaces.exterior_inside_upper;
    S2_down = tank_surfaces.exterior_inside_lower;
    S2      = im_data(S2_up:S2_down, :);
    
    S3_up   = tank_surfaces.inferior_outside_upper;
    S3_down = tank_surfaces.inferior_outside_lower;
    S3      = im_data(S3_up:S3_down, :);
    
    S4_up   = tank_surfaces.inferior_inside_upper;
    S4_down = tank_surfaces.inferior_inside_lower;
    S4      = im_data(S4_up:S4_down, :);

    function show_plot(S, msg)
        column_averages = zeros(1, length(S));
        for i=1:length(S)
            column_averages(i) = mean(S(:, i));
        end
        gradient_data = smooth_gradient(column_averages);
        newfigure(msg);
        plot((1:512), column_averages, 'b', ...
             (1:512), gradient_data, 'r');
    end
    
    show_plot(S1, 'exterior outside');
    show_plot(S2, 'exterior inside');
    show_plot(S3, 'inferior outside');
    show_plot(S4, 'inferior inside');
end
