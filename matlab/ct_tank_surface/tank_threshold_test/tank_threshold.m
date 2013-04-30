function threshold_val = tank_threshold(filename)
    im = dicomread(filename);
    [values, counts] = myhist(im);
    plot(values, counts);
    [max_peaks, min_peaks] = peakdet(counts, 300);
    threshold_val = values(max(min_peaks(:, 1)));
end
