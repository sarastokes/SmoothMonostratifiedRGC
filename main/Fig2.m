%% Figure 2
% - Last updated figure: 13Sep2023
% --

savePlots = true;
saveDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells';

c1321 = Neuron(1321, 'i', true);
c5370 = Neuron(5370, 'i', true);
c18269 = Neuron(18269, 'i', true);
c5063 = Neuron(5063, 'i', true);

mainColor = [0.4 0.4 0.4];
ribbonColor = rgb('sky blue');
convColor = rgb('peach');
markerAlpha = 0.8;

%% Fig 2A - Smooth RGC ---------------------------------------------------
ax = axes('Parent', figure()); hold on;
h2 = mark3D(c1321.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', convColor, 'Scatter', true);
h1 = mark3D(c1321.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 36);
ax = c1321.render('FaceColor', mainColor, 'FaceAlpha', 0.8, 'ax', ax);
lightangle(45,30); lightangle(225,30);
view(0, 90); toggleAxes();
sb = plot3([215 235], [1 1], [50 50], 'k', 'LineWidth', 1.5);
figPos(gcf, 1.5, 1.5)
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig2A.png'), '-dpng', '-r600');
end

%% Fig 2B, 2C & 2D - Parasol RGCs ----------------------------------------
ax = axes('Parent', figure()); hold(ax, 'on');
h2 = mark3D(c5370.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', convColor, 'Scatter', true);
h1 = mark3D(c5370.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
c5370.render('FaceColor', mainColor, 'FaceAlpha', 0.8, 'ax', ax);
lightangle(90, 30); lightangle(225, 30);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 40);
sb = plot3([67 87], [154 154], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig2B.png'), '-dpng', '-r600');
end


ax = axes('Parent', figure()); hold(ax, 'on');
h1 = mark3D(c18269.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', hex2rgb('00cc4d'), 'Scatter', true);
h2 = mark3D(c18269.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', rgb('salmon'), 'Scatter', true);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', markerSize);
c18269.render('FaceColor', mainColor, 'FaceAlpha', 0.8, 'ax', ax);
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig2C.png'), '-dpng', '-r600');
end

ax = golgi(c5063, 'FaceAlpha', 1, 'Color', mainColor);
h1 = mark3D(c5063.Neuron.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', hex2rgb('00cc4d'), 'Scatter', true);
h2 = mark3D(c5063.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', rgb('salmon'), 'Scatter', true);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', markerSize);
tightfig(gcf);


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