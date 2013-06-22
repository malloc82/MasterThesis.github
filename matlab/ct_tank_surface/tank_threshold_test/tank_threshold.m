function threshold_val = tank_threshold(filename, plot_opt)
    if nargin == 1
        plot_opt = 0;
    end
    im = dicomread(filename);
    [values, counts] = myhist(im);
    if plot_opt == 1, plot(values, counts); end
    [max_peaks, min_peaks] = peakdet(counts, 120);
    threshold_val = values(max(min_peaks(:, 1)));
end
