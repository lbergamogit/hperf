function figure_format(f)

if nargin < 1
    f = gcf;
end

ax = get(f, 'children');
for iax = 1:length(ax)
    if strcmpi(ax(iax).Type, 'axes')
        grid(ax(iax), 'on')
        box(ax(iax), 'on')
        set(ax(iax), 'fontname', 'Serif')
        set(ax(iax), 'fontsize', 10)
        set(ax(iax), 'TickDir', 'in')
        set(ax(iax), 'TickLength', [.02 .02])
        set(ax(iax), 'XMinorTick', 'on')
        set(ax(iax), 'YMinorTick', 'on')
        set(ax(iax), 'XColor', [0 0 0])
        set(ax(iax), 'YColor', [0 0 0])
        set(ax(iax), 'LineWidth', 1)
        set(ax(iax), 'GridLineStyle', '-')
        set(ax(iax), 'GridColor', [0 0 0])
        set(ax(iax), 'GridAlpha', 0.15)
        
        ch = get(ax(iax), 'children');
        for ich = 1:length(ch)
            if strcmpi(ch(ich).Type, 'line')
                set(ch(ich), 'linewidth', 1.5)
            end
        end
    end
end

end



