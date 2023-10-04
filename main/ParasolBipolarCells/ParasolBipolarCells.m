
savePlots = true;
saveDir = fullfile(getSmoothMonoRepoDir(), "main", "ParasolBipolarCells");

run('loadKeyRGCs.m');

mainColor = [0 0 0]; %[0.15, 0.15, 0.15];
giantColor = hex2rgb('f3c14a');
db4Color = hex2rgb('dc2a33'); % BE273E
db5Color = hex2rgb('5c99cc');
db6Color = rgb('lavender');
midgetColor = hex2rgb('26E096');%  hex2rgb('14A56B');
idkColor = [0.6 0.6 0.6];

%% Classify the presynaptic bipolar cells
T18269 = getLinkedBipolarTypes(c18269);

db5XYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "DB5")), 'SynapseXYZ'};
db4XYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "DB4")), 'SynapseXYZ'};
db6XYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "DB6")), 'SynapseXYZ'};
giantXYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "Giant")), 'SynapseXYZ'};
midgetXYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "Midget")), 'SynapseXYZ'};
idkXYZ = c18269.links{ismember(c18269.links.NeuronID,...
    T18269.NeuronID(T18269.Class == "Unclassified")), 'SynapseXYZ'};

%% Figure 6A
ax = golgi(c18269, 'Color', mainColor);
clipMesh(findByTag(ax, 'c18269'), 38, true);
set(findByTag(ax, 'c18269'), 'FaceAlpha', 1);
plot3([140 150], [61 61], [50 50], 'k', 'LineWidth', 1.5);

hU = mark3D(idkXYZ, 'ax', ax, 'Color', idkColor, 'Scatter', true);
h6 = mark3D(db6XYZ, 'ax', ax, 'Color', rgb('lavender'), 'Scatter', true);
hM = mark3D(midgetXYZ, 'ax', ax, 'Color', midgetColor, 'Scatter', true);
hG = mark3D(giantXYZ, 'ax', ax, 'Color', giantColor, 'Scatter', true);
h5 = mark3D(db5XYZ, 'ax', ax, 'Color', db5Color, 'Scatter', true);
h4 = mark3D(db4XYZ, 'ax', ax, 'Color', db4Color, 'Scatter', true);
set([hU, hG, h5, h4, h6, hM], 'MarkerFaceAlpha', 1, 'SizeData', 30);

hU.ZData(:) = ax.ZLim(2) + 1;
hG.ZData(:) = ax.ZLim(2) + 1;
hM.ZData(:) = ax.ZLim(2) + 1;
h4.ZData(:) = ax.ZLim(2) + 1;
h5.ZData(:) = ax.ZLim(2) + 1;
h6.ZData(:) = ax.ZLim(2) + 1;

tightfig(gcf);

if savePlots
    exportgraphics(gca, fullfile(saveDir, 'c18269_SynapseMarkers.png'),...
        "Resolution", 600);
end

%% Figure 6B
[ax, h] = golgi(c18269, 'Color', mainColor);
clipMesh(findByTag(ax, 'c18269'), 38, true);
plot3([215 225]-5, [55 55], [50 50], 'k', 'LineWidth', 1.5);

db4IDs = T18269.NeuronID(T18269.Class == "DB4");
for i = 1:numel(db4IDs)
    golgi(Neuron(db4IDs(i), 'i'), 'ax', ax, 'FaceColor', db4Color);
    SMPaperRGC.clipBipolar(db4IDs(i), ax);
    drawnow;
end

db5IDs = T18269.NeuronID(T18269.Class == "DB5");
for i = 1:numel(db5IDs)
    golgi(Neuron(db5IDs(i), 'i'), 'ax', ax, 'FaceColor', db5Color);
    SMPaperRGC.clipBipolar(db5IDs(i), ax);
    drawnow;
end

db6IDs = T18269.NeuronID(T18269.Class == "DB6");
for i = 1:numel(db6IDs)
    golgi(Neuron(db6IDs(i), 'i'), 'ax', ax, 'FaceColor', db6Color);
    SMPaperRGC.clipBipolar(db6IDs(i), ax);
    drawnow;
end

midgetIDs = T18269.NeuronID(T18269.Class == "Midget");
for i = 1:numel(midgetIDs)
    [~, h] = golgi(Neuron(midgetIDs(i), 'i'), 'ax', ax,...
        'FaceColor', midgetColor);
    SMPaperRGC.clipBipolar(midgetIDs(i), ax);
    drawnow;
end

giantIDs = T18269.NeuronID(T18269.Class == "Giant");
for i = 1:numel(giantIDs)
    [~, h] = golgi(Neuron(giantIDs(i), 'i'), 'ax', ax,...
        'FaceColor', giantColor);
    SMPaperRGC.clipBipolar(giantIDs(i), ax);
    drawnow;
end

set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
tightfig(gcf);
if savePlots
    exportgraphics(ax, fullfile(saveDir, 'c18269_BipolarCells.png'),...
        "Resolution", 600);
end

%% Single BC figures
% Additional figures are modified versions of the one above
toggleColor = @(x, y, z) set(findall(y, 'FaceColor', x), 'Visible', z);

toggleColor(db6Color, ax, 'off');
toggleColor(giantColor, ax, 'off');
x = xlim(); y = ylim();
xlim(x); ylim(y);

%% Figure 6C
toggleColor(db4Color, ax, 'on');
toggleColor(db5Color, ax, 'off');
toggleColor(midgetColor, ax, 'off');
xlim(x); ylim(y);
if savePlots
    exportgraphics(ax, fullfile(saveDir, 'c18269_DB4.png'),...
        "Resolution", 600);
end

%% Figure 6D
toggleColor(db4Color, ax, 'off');
toggleColor(db5Color, ax, 'on');
xlim(x); ylim(y);
if savePlots
    exportgraphics(ax, fullfile(saveDir, 'c18269_DB5.png'),...
        "Resolution", 600);
end

%% Figure 6E
toggleColor(db5Color, ax, 'off');
toggleColor(midgetColor, ax, 'on');
if savePlots
    exportgraphics(ax, fullfile(saveDir, 'c18269_Midget.png'),...
        "Resolution", 600);
end