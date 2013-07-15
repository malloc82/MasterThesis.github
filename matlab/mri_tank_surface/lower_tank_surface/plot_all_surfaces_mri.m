function plot_all_surfaces_mri(surfaces_data)
    newfigure('MRI tank surfaces')
    hold on
    grid on
    % if ~isempty(surfaces_data.S1)
    %     tri = delaunay(surfaces_data.S1(:, 1), surfaces_data.S1(:, 2));
    %     h = trisurf(tri, surfaces_data.S1(:, 1), surfaces_data.S1(:, 2), surfaces_data.S1(:, 3));    
    % end 
    % if ~isempty(surfaces_data.S2)
    %     tri = delaunay(surfaces_data.S2(:, 1), surfaces_data.S2(:, 2));
    %     h = trisurf(tri, surfaces_data.S2(:, 1), surfaces_data.S2(:, 2), surfaces_data.S2(:, 3));    
    % end 
    % if ~isempty(surfaces_data.S3)
    %     tri = delaunay(surfaces_data.S3(:, 1), surfaces_data.S3(:, 2));
    %     h = trisurf(tri, surfaces_data.S3(:, 1), surfaces_data.S3(:, 2), surfaces_data.S3(:, 3));    
    % end 
    % if ~isempty(surfaces_data.S4)
    %     tri = delaunay(surfaces_data.S4(:, 1), surfaces_data.S4(:, 2));
    %     h = trisurf(tri, surfaces_data.S4(:, 1), surfaces_data.S4(:, 2), surfaces_data.S4(:, 3));    
    % end 
    
    % ------ scatter3 --------
    if ~isempty(surfaces_data.S1)
        scatter3(surfaces_data.S1(:, 1),  surfaces_data.S1(:, 2),  surfaces_data.S1(:, 3),  'r'); 
    end 
    if ~isempty(surfaces_data.S2)
        scatter3(surfaces_data.S2(:, 1),  surfaces_data.S2(:, 2),  surfaces_data.S2(:, 3),  'r'); 
    end 
    if ~isempty(surfaces_data.S3)
        scatter3(surfaces_data.S3(:, 1),  surfaces_data.S3(:, 2),  surfaces_data.S3(:, 3),  'r'); 
    end 
    if ~isempty(surfaces_data.S4)
        scatter3(surfaces_data.S4(:, 1),  surfaces_data.S4(:, 2),  surfaces_data.S4(:, 3),  'r'); 
    end 
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off
end
