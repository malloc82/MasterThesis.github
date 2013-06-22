function coordinates3D = dicom_coordinate(pixel_coordinates, position, orientation, spacing)
    M = [orientation(4) * spacing(1)   orientation(1) * spacing(2)   0   position(1)
         orientation(5) * spacing(1)   orientation(2) * spacing(2)   0   position(2)
         orientation(6) * spacing(1)   orientation(3) * spacing(2)   0   position(3)];
    
    [row col] = size(pixel_coordinates);
    
    if row > col
        coordinates3D = M * [pixel_coordinates zeros(row, 1) ones(row, 1)]';
        coordinates3D = coordinates3D';
    elseif col > row || (col == 2 && row == 2)
        coordinates3D = M * [pixel_coordinates; zeros(1, col); ones(1, col)];
    end
end
