%% Figure 3
% - Last Updated Figures: 17Sept2023
% --

c1321 = Neuron(1321, 'i', true);
c5370 = Neuron(5370, 'i', true);
c18269 = Neuron(18269, 'i', true);
c5063 = Neuron(5063, 'i', true);

%% Figure 3 --------------------------------------------------------------
[hR, hA] = scatterIE(c18269, bins=15,...
    markers=false, dendrite=true, square=true,...
    smoothFac=1,clevels=11,branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [139 149], [59 59], [50 50], 'k', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c18269_Plot%u.png', i)), 'Resolution', 600);
end

[hR, hA] = scatterIE(c1321, bins=23, markers=false, dendrite=true, square=true,smoothFac=1,clevels=11,branch=true);
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [215 235], [-15 -15], [50 50], 'k', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c1321_Plot%u.png', i)), 'Resolution', 600);
end

[hR, hA] = scatterIE(c5063, bins=16,...
    markers=false, dendrite=true, square=true,...
    smoothFac=1,clevels=11,branch=true); % 4.751
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [92 102], [67 67], [50 50], 'k', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c5063_Plot%u.png', i)), 'Resolution', 600);
end

[hR, hA] = scatterIE(c5370, bins=15,...
    markers=false, dendrite=true, square=true,...
    smoothFac=1,clevels=11,branch=true); % 4.762
axHandles = findall(gcf, 'Type', 'axes');
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [67 77], [147 147], [50 50], 'k', 'LineWidth', 1);
    exportgraphics(axHandles(i), fullfile(saveDir, sprintf('c5370_Plot%u.png', i)), 'Resolution', 600);
end