%% Figure 4
% Last updated figures: 21Sep2023 (A-C)
% --

saveDir = fullfile(getSmoothMonoRepoDir(), 'main', 'Fig4_SmoothBCs');
savePlots = true;

mainColor = [0.15, 0.15, 0.15];
giantColor = hex2rgb('f3c14a');
db4Color = hex2rgb('dc2a33');
db5Color = hex2rgb('5c99cc');
midgetColor = hex2rgb('7bbe88');
idkColor = [0.6 0.6 0.6];

T1321 = getLinkedBipolarTypes(c1321);

db4IDs = T1321{T1321.Class == "DB4", "NeuronID"};
db5IDs = T1321{T1321.Class == "DB5", "NeuronID"};
giantIDs = T1321{T1321.Class == "Giant", "NeuronID"};

%% Classify the presynaptic bipolar cells
db5XYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "DB5")), 'SynapseXYZ'};
db4XYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "DB4")), 'SynapseXYZ'};
giantXYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "Giant")), 'SynapseXYZ'};
idkXYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "Unclassified")), 'SynapseXYZ'};

%% Figure 4A
ax = golgi(c1321, 'Color', mainColor);
set(findByTag(ax, 'c1321'), 'FaceAlpha', 1);
plot3([215 235], [1 1], [0 0], 'k', 'LineWidth', 1.5);

hU = mark3D(idkXYZ, 'ax', ax, 'Color', idkColor, 'Scatter', true);
hG = mark3D(giantXYZ, 'ax', ax, 'Color', giantColor, 'Scatter', true);
h5 = mark3D(db5XYZ, 'ax', ax, 'Color', db5Color, 'Scatter', true);
h4 = mark3D(db4XYZ, 'ax', ax, 'Color', db4Color, 'Scatter', true);
set([hU, hG, h5, h4], 'MarkerFaceAlpha', 0.8, 'SizeData', 25);

if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig6.png'),...
        "Resolution", 600);
end

%% Figure 4B
% DB4 bipolar cell input
ax1 = golgi(c1321, 'Color', [0.15 0.15 0.15]);
set(findobj(ax, 'Tag', 'c1321'), 'FaceAlpha', 1);
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);

for i = 1:numel(db4IDs)
    golgi(Neuron(db4IDs(i), 'i'), 'ax', ax, 'Color', db4Color);
    SMPaperRGC.clipBipolar(db4IDs(i), ax);
    drawnow;
end
tightfig(gcf);

% DB5 bipolar cell input
ax2 = golgi(c1321, 'Color', [0.15 0.15 0.15]);
set(findobj(ax, 'Tag', 'c1321'), 'FaceAlpha', 1);
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);

for i = 1:numel(db5IDs)
    golgi(Neuron(db5IDs(i), 'i'), 'ax', ax, 'Color', db5Color);
    SMPaperRGC.clipBipolar(db5IDs(i), ax);
    drawnow;
end
tightfig(gcf);


% Giant bipolar cell input
ax3 = golgi(c1321, 'Color', [0.15 0.15 0.15]);
set(findobj(ax, 'Tag', 'c1321'), 'FaceAlpha', 1);
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);

for i = 1:numel(giantIDs)
    golgi(Neuron(giantIDs(i), 'i'), 'ax', ax, 'Color', giantColor);
    SMPaperRGC.clipBipolar(giantIDs(i), ax);
    drawnow;
end
tightfig(gcf);

% Match the axes
[xMin, xMax] = bounds([ax1.XLim, ax2.XLim, ax3.XLim]);
xlim([ax1, ax2, ax3], [xMin, xMax]);

[yMin, yMax] = bounds([ax1.YLim, ax2.YLim, ax3.YLim]);
ylim([ax1, ax2, ax3], [yMin, yMax]);

% Save the plots
if savePlots
    exportgraphics(ax1, fullfile(saveDir, 'Fig4C.png'), "Resolution", 600);
    exportgraphics(ax2, fullfile(saveDir, 'Fig4D.png'), "Resolution", 600);
    exportgraphics(ax3, fullfile(saveDir, 'Fig4E.png'), "Resolution", 600);
end