function [S1 S2 S3 S4] = get_ct_tank_surfaces(data_set_dir, image_file)
% inputs : 
%         First argument:  imageset path
%         Second argument: for testing purpose, could be omitted

    addpath(sprintf('%s/%s', pwd, '../lib'));
    function [S1_3d S2_3d S3_3d S4_3d] = convert(S1_2d, S2_2d, S3_2d, S4_2d, position, orientation, spacing)
        if isempty(S1_2d), S1_3d = []; else, S1_3d = dicom_coordinate(S1_2d, position, orientation, spacing); end
        if isempty(S2_2d), S2_3d = []; else, S2_3d = dicom_coordinate(S2_2d, position, orientation, spacing); end
        if isempty(S3_2d), S3_3d = []; else, S3_3d = dicom_coordinate(S3_2d, position, orientation, spacing); end
        if isempty(S4_2d), S4_3d = []; else, S4_3d = dicom_coordinate(S4_2d, position, orientation, spacing); end
    end 
    if nargin == 1
        image_set = getAllFiles(data_set_dir);
        mid_sample_index = int32(length(image_set) / 2);
        mid_image_sample = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index}));
        
        surfaces_locations = locate_surfaces(mid_image_sample);
        fprintf('mid sample : %s/%s\n', data_set_dir, image_set{mid_sample_index});

        im_info1 = dicominfo(image_set{1});
        im_info2 = dicominfo(image_set{10});
 
        % S1 = [];
        % S2 = [];
        % S3 = [];
        % S4 = [];

        [S1 S2 S3 S4 boundary_info] = get_surface_data(image_set{mid_sample_index}, surfaces_locations)
        im_info = dicominfo(image_set{mid_sample_index});
        spacing     = im_info.PixelSpacing;
        position    = im_info.ImagePositionPatient;
        orientation = im_info.ImageOrientationPatient;
        [S1 S2 S3 S4] = convert(S1, S2, S3, S4, position, orientation, spacing);
        
        b_info = boundary_info;
        for i=mid_sample_index-1:-1:1
            fprintf('\n==> i    =    %d\n', i);

            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;

            [s1 s2 s3 s4 b_info] = get_surface_data(image_set{i}, surfaces_locations, b_info);

            [s1 s2 s3 s4] = convert(s1, s2, s3, s4, position, orientation, spacing);
            S1 = [S1; s1];
            S2 = [S2; s2];
            S3 = [S3; s3];
            S4 = [S4; s4];
        end 

        b_info = boundary_info;
        for i=mid_sample_index+1:length(image_set)
            fprintf('\n==> i    =    %d\n', i);

            im_info     = dicominfo(image_set{i});
            spacing     = im_info.PixelSpacing;
            position    = im_info.ImagePositionPatient;
            orientation = im_info.ImageOrientationPatient;

            [s1 s2 s3 s4 b_info] = get_surface_data(image_set{i}, surfaces_locations, b_info);

            [s1 s2 s3 s4] = convert(s1, s2, s3, s4, position, orientation, spacing);
            S1 = [S1; s1];
            S2 = [S2; s2];
            S3 = [S3; s3];
            S4 = [S4; s4];            
        end 
    else 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This part is for testing %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        image_filename = sprintf('%s/%s', data_set_dir, image_file);
        % mid_image = dicomread(image_filename);
        mid_image = dicomread(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_250.dcm'));
        newfigure('original mid slice');
        imshow(mid_image, []);

        im_info1 = dicominfo(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_250.dcm'));
        im_info2 = dicominfo(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_251.dcm'));
        mask = [im_info2.ImagePositionPatient - im_info1.ImagePositionPatient == 0]
        
        surfaces_locations = locate_surfaces(mid_image);

        image_data  = dicomread(image_filename);
        image_info  = dicominfo(image_filename);
        spacing     = image_info.PixelSpacing;
        position    = image_info.ImagePositionPatient;
        orientation = image_info.ImageOrientationPatient;

        newfigure('original image');
        imshow(image_data, []);
        
        if isempty(surfaces_locations)
            display('surface locations empty');
            S1 = [];
            S2 = [];
            S3 = [];
            S4 = [];
            return;
        end
        [S1 S2 S3 S4] = get_surface_data(image_filename, surfaces_locations);
        mark_image(image_data, {S1 S2 S3 S4}, sprintf('marked : %s', image_filename));
        
        [S1 S2 S3 S4] = convert(S1, S2, S3, S4, position, orientation, spacing);
    end
end
