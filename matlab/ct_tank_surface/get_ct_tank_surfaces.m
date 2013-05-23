function [S1 S2 S3 S4] = get_ct_tank_surfaces(data_set_dir, image_file)
% inputs : 
%         First argument:  imageset path
%         Second argument: for testing purpose, could be omitted

    addpath(sprintf('%s/%s', pwd, '../lib'));
    function [S1_3d S2_3d S3_3d S4_3d] = convert(S1_2d, S2_2d, S3_2d, S4_2d, mask, corner)
        if ~isempty(S1_2d)
            S1_3d = transform_2d_to_3d(S1_2d.*spacing(ones(length(S1_2d), 1), :), mask') ...
                    + repmat(corner', [length(S1_2d) 1]);
        else 
            S1_3d = [];
        end
        if ~isempty(S2_2d)
            S2_3d = transform_2d_to_3d(S2_2d.*spacing(ones(length(S2_2d), 1), :), mask') ...
                    + repmat(corner', [length(S2_2d) 1]);
        else 
            S2_3d = [];
        end
        if ~isempty(S3_2d)
            S3_3d = transform_2d_to_3d(S3_2d.*spacing(ones(length(S3_2d), 1), :), mask') ...
                    + repmat(corner', [length(S3_2d) 1]);
        else 
            S3_3d = [];
        end
        if ~isempty(S4_2d)
            S4_3d = transform_2d_to_3d(S4_2d.*spacing(ones(length(S4_2d), 1), :), mask') ...
                    + repmat(corner', [length(S4_2d) 1]);
        else 
            S4_3d = [];
        end
    end
    if nargin == 1
        image_set = getAllFiles(data_set_dir);
        mid_sample_index = int32(length(image_set) / 2);
        mid_image_sample = dicomread(sprintf('%s/%s', data_set_dir, image_set{mid_sample_index}));
        
        surfaces_locations = locate_surfaces(mid_image_sample);
        fprintf('mid sample : %s/%s\n', data_set_dir, image_set{mid_sample_index});

        im_info1 = dicominfo(image_set{1});
        im_info2 = dicominfo(image_set{2});
        mask = [im_info2.ImagePositionPatient - im_info1.ImagePositionPatient == 0];
 
        S1 = [];
        S2 = [];
        S3 = [];
        S4 = [];
        
        for i=1:length(image_set)
            i
            im_info = dicominfo(image_set{i});
            spacing = im_info.PixelSpacing';
            corner  = im_info.ImagePositionPatient;
            [s1 s2 s3 s4] = get_surface_data(image_set{i}, surfaces_locations);
            [s1 s2 s3 s4] = convert(s1, s2, s3, s4, mask, corner);
            % s1 = transform_2d_to_3d(s1.*spacing(ones(length(s1), 1), :), mask') + ...
            %      repmat(corner', [length(s1) 1]);
            % s2 = transform_2d_to_3d(s2.*spacing(ones(length(s2), 1), :), mask') + ...
            %      repmat(corner', [length(s2) 1]);
            % s3 = transform_2d_to_3d(s3.*spacing(ones(length(s3), 1), :), mask') + ...
            %      repmat(corner', [length(s3) 1]);
            % s4 = transform_2d_to_3d(s4.*spacing(ones(length(s4), 1), :), mask') + ...
            %      repmat(corner', [length(s4) 1]);
            S1 = [S1; s1];
            S2 = [S2; s2];
            S3 = [S3; s3];
            S4 = [S4; s4];
        end
    else 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % This part is for testing
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        image_filename = sprintf('%s/%s', data_set_dir, image_file);
        % mid_image = dicomread(image_filename);
        mid_image = dicomread(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_250.dcm'));
        newfigure('original mid slice');
        imshow(mid_image, []);

        im_info1 = dicominfo(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_250.dcm'));
        im_info2 = dicominfo(sprintf('%s/%s', '../../data/ct_5346_coronal', '20121017_251.dcm'));
        mask = [im_info2.ImagePositionPatient - im_info1.ImagePositionPatient == 0]
        
        surfaces_locations = locate_surfaces(mid_image);

        image_data = dicomread(image_filename);
        image_info = dicominfo(image_filename);

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
        
        spacing = (image_info.PixelSpacing)';
        corner  = image_info.ImagePositionPatient
        % S1 = transform_2d_to_3d(S1.*spacing(ones(length(S1), 1), :), mask') + repmat(corner', [length(S1) 1]);
        % S2 = transform_2d_to_3d(S2.*spacing(ones(length(S2), 1), :), mask') + repmat(corner', [length(S2) 1]);
        % S3 = transform_2d_to_3d(S3.*spacing(ones(length(S3), 1), :), mask') + repmat(corner', [length(S3) 1]);
        % S4 = transform_2d_to_3d(S4.*spacing(ones(length(S4), 1),
        % :), mask') + repmat(corner', [length(S4) 1]);
        [S1 S2 S3 S4] = convert(S1, S2, S3, S4, mask, corner);
        spacing
        corner
    end
end
