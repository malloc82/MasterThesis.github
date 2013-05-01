function view_dicom(filename)
    [folder, name, ext] = fileparts(filename);
    newfigure(sprintf('%s.%s', name, ext));
    imshow(dicomread(filename), []);
end
