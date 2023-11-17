%% Figure 3
% - Last Updated Figures: 17Nov2023
% --

saveDir = fullfile(getSmoothMonoRepoDir(), "main", "Fig3_DensityMaps");
savePlots = true;
run('loadKeyRGCs.m')

figNames = ["AmacrineDensity", "BipolarDensity", "DendriteDensity"];

%% Figure 3A: Smooth RGCs
scatterIE(c1321, bins=[35 23 23], smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2));
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [215 235], [-15 -15], [50 50], 'w', 'LineWidth', 1);
    if savePlots
        exportgraphics(axHandles(i),...
            fullfile(saveDir, sprintf('c1321_%s.png', figNames(i))),...
            'Resolution', 600);
    end
end

%% Figure 3B-D: Parasol RGCs
scatterIE(c18269, bins=[20 15 15], smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2));
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [139 149], [59 59], [50 50], 'w', 'LineWidth', 1);
    if savePlots
        exportgraphics(axHandles(i),...
            fullfile(saveDir, sprintf('c18269_AltPlot%s.png', figNames(i))),...
            'Resolution', 600);
    end
end

scatterIE(c5370, bins=[20 15 15], smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [67 77], [147 147], [50 50], 'w', 'LineWidth', 1);
    if savePlots
        exportgraphics(axHandles(i),...
            fullfile(saveDir, sprintf('c5370_AltPlot%s.png', figNames(i))),...
            'Resolution', 600);
    end
end

scatterIE(c5063, bins=[21 15 15], smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2));
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [92 102], [67 67], [50 50], 'w', 'LineWidth', 1);
    if savePlots
        exportgraphics(axHandles(i),...
            fullfile(saveDir, sprintf('c5063_%s.png', figNames(i))),...
            'Resolution', 600);
    end
end