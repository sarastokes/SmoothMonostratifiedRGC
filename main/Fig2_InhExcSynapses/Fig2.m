%% Figure 2
% - Last updated figure: 13Sep2023
% --

savePlots = true;
saveDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells';

c1321 = Neuron(1321, 'i', true);
c5370 = Neuron(5370, 'i', true);
c18269 = Neuron(18269, 'i', true);
c5063 = Neuron(5063, 'i', true);

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
c5370.render('FaceColor', parasolColor, 'FaceAlpha', 0.8, 'ax', ax);
lightangle(110, 40); lightangle(216, 36);
set([h1, h2], 'MarkerFaceAlpha', markerAlpha, 'SizeData', 40);
plot3([67 87], [154 154], [0 0], 'k', 'LineWidth', 1.5);
hideAxes(); tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig2B.png'), 'Resolution', 600);
end


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
