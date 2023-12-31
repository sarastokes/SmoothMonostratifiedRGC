%% Figure 2
% - Last updated figure: 17Nov2023
% --

savePlots = true;
saveDir = fullfile(getSmoothMonoRepoDir(), "main", "Fig2_Synapses");

run('loadKeyRGCs.m');

smoothColor = [0.4 0.4 0.4];
parasolColor = [0.6 0.6 0.6];
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
ax = c1321.render('FaceColor', smoothColor, 'FaceAlpha', 0.8, 'ax', ax);
lightangle(90, 30); lightangle(225, 30);
view(0, 90); toggleAxes();
plot3([215 235], [1 1], [50 50], 'k', 'LineWidth', 1.5);
figPos(gcf, 1.5, 1.5)
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig2A.png'), '-dpng', '-r600');
end

%% Fig 2B - Parasol 5370 --------------------------------------------------
ax = axes('Parent', figure()); hold(ax, 'on');
h2 = mark3D(c5370.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', convColor, 'Scatter', true);
h1 = mark3D(c5370.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
c5370.render('FaceColor', parasolColor, 'FaceAlpha', 0.8, 'ax', ax);
lightangle(110, 40); lightangle(216, 36);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 40);
plot3([67 87], [154 154], [0 0], 'k', 'LineWidth', 1.5);
hideAxes(); tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig2B.png'), 'Resolution', 600);
end

%% Fig 2C - Parasol 18269 -------------------------------------------------
ax = axes('Parent', figure()); hold(ax, 'on');
h2 = mark3D(c18269.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', convColor, 'Scatter', true);
h1 = mark3D(c18269.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 40);
h0 = c18269.render('ax', ax,...
    'FaceColor', parasolColor, 'FaceAlpha', 0.8);
clipMesh(h0, 20, true);
lightangle(110, 40); lightangle(216, 36);
plot3([140 160], [62.2 62.2], [50 50], 'k', 'LineWidth', 1.5);
hideAxes(); tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig2C.png'), 'Resolution', 600);
end

%% Fig 2D - Parasol 5063 --------------------------------------------------
ax = axes('Parent', figure()); hold(ax, 'on');
h2 = mark3D(c5063.getSynapseXYZ('ConvPost'),...
    'ax', ax, 'Color', convColor, 'Scatter', true);
h1 = mark3D(c5063.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
h0 = c5063.render('ax', ax,...
    'FaceColor', mainColor, 'FaceAlpha', 0.8);
clipMesh(h0, 44, true);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 40);
lightangle(110, 40); lightangle(216, 36);
sb = plot3([101 121], [67 67], [50 50], 'k', 'LineWidth', 1.5);
hideAxes(); tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig2D.png'), 'Resolution', 600);
end
