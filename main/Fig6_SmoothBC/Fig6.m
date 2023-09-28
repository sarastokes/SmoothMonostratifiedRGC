%% Figure 6
% - Last updated figure: 20Sept2023 SSP
% --

savePlots = true;
saveDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells';

c1321 = Neuron(1321, 'i', true);
c1321.getLinks();

mainColor = [0.15, 0.15, 0.15];
giantColor = hex2rgb('f3c14a');
db4Color = hex2rgb('dc2a33');
db5Color = hex2rgb('5c99cc');
midgetColor = hex2rgb('7bbe88');
idkColor = [0.6 0.6 0.6];

%% Classify the presynaptic bipolar cells
T1321 = getLinkedBipolarTypes(c1321);

db5XYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "DB5")), 'SynapseXYZ'};
db4XYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "DB4")), 'SynapseXYZ'};
giantXYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "Giant")), 'SynapseXYZ'};
idkXYZ = c1321.links{ismember(c1321.links.NeuronID, T1321.NeuronID(T1321.Class == "Unclassified")), 'SynapseXYZ'};

%% Figure 6A
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


%% Figure 6B
% Use annotations to determine x and y extent
annotations = c1321.getCellXYZ();
[xMin, xMax] = bounds(annotations(:,1));
[yMin, yMax] = bounds(annotations(:,2));
% Make it equal so bins are square
xyDiff = (yMax-yMin) - (xMax-xMin);
if xyDiff > 0
    xMin = xMin - abs(xyDiff/2);
    xMax = xMax + abs(xyDiff/2);
else
    yMax = yMax + abs(xyDiff/2);
    yMin = yMin - abs(xyDiff/2);
end
xBound = [xMin xMax];
yBound = [yMin yMax];

% Extra settings
numBins = 23;
cmap = lighten(slanCM('thermal-2'), 0.1);

% Plotting
figure();
subplot(1,3,1); hold on;
title('DB5 Bipolar Cell');
h5 = scattercloud(db5XYZ(:,1), db5XYZ(:,2),...
    numBins, 1, '.w', slanCM('plasma'), xBound, yBound);
[~, h0] = golgi(c1321, 'ax', gca, 'Color', 'k');
set(h0, 'FaceAlpha', 1);
delete(h5(2));
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);
hideAxes();
colormap(cmap);

subplot(1,3,2); hold on;
title('DB4 Bipolar Cell');
h4 = scattercloud(db4XYZ(:,1), db4XYZ(:,2),...
    numBins, 1, '.w', slanCM('plasma'), xBound, yBound);
delete(h4(2));
[~, h0] = golgi(c1321, 'ax', gca, 'Color', 'k');
set(h0, 'FaceAlpha', 1);
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);
hideAxes();
colormap(cmap);

subplot(1,3,3); hold on;
title('Giant Bipolar Cell');
hG = scattercloud(giantXYZ(:,1), giantXYZ(:,2),...
    numBins, 1, '.w', slanCM('plasma'), xBound, yBound);
delete(hG(2));
[~, h0] = golgi(c1321, 'ax', gca, 'Color', 'k');
set(h0, 'FaceAlpha', 1);
plot3(ax, [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);
hideAxes();
colormap(cmap);


% Normalize subplots together
axHandles = findall(gcf, 'Type', 'axes');
cMax = max(vertcat(axHandles.CLim), [], "all");
set(axHandles, 'CLim', [0 cMax]);
fprintf('Colormap max = %.3f\n', cMax);

bcTypes = ["DB5", "DB4", "Giant"];
for i = 1:numel(axHandles)
    title(axHandles(i), "");
    plot3(axHandles(i), [215 235], [1 1], [0 0], 'k', 'LineWidth', 1);
    exportgraphics(axHandles(i), ...
        fullfile(saveDir, sprintf('Fig6B_%s.png', bcTypes(i))),...
        "Resolution", 600);
end