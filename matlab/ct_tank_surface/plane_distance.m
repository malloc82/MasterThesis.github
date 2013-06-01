function D = plane_distance(S1, S2)
% this needs to be updated with correct coordinate calculation
% http://nipy.sourceforge.net/nibabel/dicom/dicom_orientation.html
    
    points = [  0   0
                0  60
                0 -60
               60   0
              -60   0];
                        
    [a1 b1 c1 d1] = plane_estimation(S1);
    [a2 b2 c2 d2] = plane_estimation(S2);
    
    d1_2 = zeros(length(points), 1);
    for i=1:length(points)
        z       = -(a1 * points(i,1) + b1 * points(i,2) + d1)/c1; % new point (x1 0 300)
        d1_2(i) = abs(a2 * points(i, 1) + b2 * points(i, 2) + c2 * z + d2) / sqrt(a2*a2 + b2*b2 + c2*c2);
    end 
    dist1 = mean(d1_2);
    
    d2_1 = zeros(length(points), 1);
    for i=1:length(points)
        z       = -(a2 * points(i,1) + b2 * points(i,2) + d2)/c2; % new point (x1 0 300)
        d2_1(i) = abs(a1 * points(i, 1) + b1 * points(i, 2) + c1 * z + d1) / sqrt(a1*a1 + b1*b1 + c1*c1);
    end 
    dist2 = mean(d2_1);
    
    D = mean([dist1; dist2]);
end
