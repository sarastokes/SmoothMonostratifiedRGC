%% Figure 3
% - Last Updated Figures: 17Sept2023
% --

saveDir = fullfile(getSmoothMonoRepoDir(), "main", "Fig3_InhExcDensity");
savePlots = true;
run('loadKeyRGCs.m')



%% Figure 3 --------------------------------------------------------------

[hR, hA] = scatterIE(c1321, bins=23, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [215 235], [-15 -15], [50 50], 'w', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c1321_AltPlot%u.png', i)), 'Resolution', 600);
end


[hR, hA] = scatterIE(c18269, bins=15, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [139 149], [59 59], [50 50], 'w', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c18269_AltPlot%u.png', i)), 'Resolution', 600);
end

[hR, hA] = scatterIE(c5370, bins=15, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [67 77], [147 147], [50 50], 'w', 'LineWidth', 1);
    exportgraphics(axHandles(i),...
        fullfile(saveDir, sprintf('c5370_AltPlot%u.png', i)),...
        'Resolution', 600);
end

[hR, hA] = scatterIE(c5063, bins=15, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [92 102], [67 67], [50 50], 'w', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c5063_AltPlot%u.png', i)), 'Resolution', 600);
end

%% Smaller samplling for dendrites
% Can we see any hotspot substructure in dendrite density maps?
[hR, hA] = scatterIE(c1321, bins=35, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
% 6.286 micron bins

axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [215 235], [-15 -15], [50 50], 'w', 'LineWidth', 1);
end
exportgraphics(axHandles(end), fullfile(saveDir, "c1321_DendriteDensity.png"), "Resolution", 600);


[hR, hA] =  scatterIE(c18269, bins=20, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
% 3.315 micron bins
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [139 149], [59 59], [50 50], 'w', 'LineWidth', 1);
end
exportgraphics(axHandles(end), fullfile(saveDir, "c18269_DendriteDensity.png"), "Resolution", 600);

% c5370
[hR, hA] =  scatterIE(c5370, bins=20, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [67 77], [147 147], [50 50], 'w', 'LineWidth', 1);
end

exportgraphics(axHandles(end),...
    fullfile(saveDir, 'c5370_DendriteDensity.png'),...
    'Resolution', 600);

% c5063

[hR, hA] =  scatterIE(c5063, bins=21, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [92 102], [67 67], [50 50], 'w', 'LineWidth', 1);
end

exportgraphics(axHandles(end),...
    fullfile(saveDir, 'c5063_DendriteDensity.png'),...
    'Resolution', 600);
