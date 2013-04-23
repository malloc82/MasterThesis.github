function newfigure(name, monitor)
    if nargin < 2 || isempty(monitor)
        monitor = 1;
    end
    scrsz = get(0,'ScreenSize');
    % scrsz = get(0,'MonitorPositions'); % MAC OS X always gets one monitor

    if nargin == 0 || isempty(name)
        fh = figure('Position', [monitor*scrsz(3) scrsz(4)/2 scrsz(4) scrsz(4)]);
    else
        fh = figure('Position', [monitor*scrsz(3) scrsz(4)/2 scrsz(4) scrsz(4)], ...
                    'Name',     name);
    end
end
