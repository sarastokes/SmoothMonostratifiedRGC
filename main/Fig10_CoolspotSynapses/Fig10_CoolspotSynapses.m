%% Figure 10C-D
% - Last updated figure: 19Sep2023
% --


saveDir = fullfile(getSmoothMonoRepoDir(), "main", "Fig10_CoolspotSynapses");
savePlots = true;

% Import main RGCs and DB4 bipolar cell
run('loadKeyRGCs.m');
c19331 = Neuron(19331, 'i');

%% Plotting styles
mainColor = [0.15 0.15 0.15];
parasolColor = [0.6 0.6 0.6; 0.8 0.8 0.8];
giantColor = hex2rgb('f3c14a');
db4Color = hex2rgb('dc2a33');
db5Color = hex2rgb('5c99cc');
midgetColor = hex2rgb('7bbe88');
cmap = linspecer(11, 'sequential'); cmap(5,:) = [];

ribbonColor = rgb('carolina blue');%rgb('sky blue');
bipolarColor = hex2rgb('E71D36');
parasolRibbonColor = hex2rgb('00cc4d');
smoothRibbonColor = hex2rgb('3772ff');

%% Set up Fig 9A-B
% Add the ganglion cells and clip axons
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', [0.5 0.5 0.5], 'ax', ax);
clipMesh(findobj(gcf, 'Tag', 'c18269'), 20, true);
drawnow;

% Add all the DB5 bipolar cells
db4s = unique(c18269.links{...
    c18269.links.SynapseType == "RibbonPost" & ...
    contains(c18269.links.NeuronLabel, 'DB4'), 'NeuronID'});
for i = 1:numel(db4s)
    golgi(Neuron(db4s(i), 'i'),...
        'Color', lighten(db4Color, 0.6), 'ax', ax);
    clipBipolar(db4s(i), ax);
end
xlim([110 225]); ylim([54 130]);

% Highlight the ones that contact the smooth RGC
smoothDB4 = db4s(ismember(db4s, c1321.links{...
    c1321.links.SynapseType == "RibbonPost", "NeuronID"}));
for i = 1:numel(smoothDB4)
    set(findobj(ax, 'Tag', ['c', num2str(smoothDB4(i))]),...
        'FaceColor', db4Color);
end

set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
xlim([110 225]); ylim([54 130]);
plot3([198 218], [54 54], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig10A.png'),...
        "Resolution", 600);
end


%% Fig 10B ----------------------------------------------------------------
% Render the neurons, cut the axons for the parasols
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', [0.5 0.5 0.5], 'ax', ax);
clipMesh(findobj(gcf, 'Tag', 'c18269'), 20, true);
xlim([110 225]); ylim([54 130]);
drawnow;

% Add the DB5 bipolar cells
db5s = unique(c18269.links{...
    c18269.links.SynapseType == "RibbonPost" & ...
    contains(c18269.links.NeuronLabel, 'DB5'), 'NeuronID'});
for i = 1:numel(db5s)
    golgi(Neuron(db5s(i), 'i'), 'Color', lighten(db5Color, 0.5), 'ax', ax);
    drawnow;
    clipBipolar(db5s(i), ax);
end
xlim([110 225]); ylim([54 130]);

smoothDB5 = db5s(ismember(db5s, c1321.links{...
    c1321.links.SynapseType == "RibbonPost", "NeuronID"}));
for i = 1:numel(smoothDB5)
    set(findobj(ax, 'Tag', ['c', num2str(smoothDB5(i))]),...
        'FaceColor', db5Color);
end

% Final formatting
set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
xlim([110 225]); ylim([54 130]);
plot3([198 218], [54 54], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);
if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig10B.png'),...
        "Resolution", 600);
end

%% Fig 10C -----------------------------------------------------------------
% Neurons
ax = golgi(c1321, 'Color', mainColor);
golgi(c19331, 'ax', ax, 'FaceColor', hex2rgb('e71d36'));
golgi(c18269, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c18269'), 20);

% Synapses
h1321 = mark3D(c1321.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', smoothRibbonColor, 'Scatter', true);
h18269 = mark3D(c18269.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color',parasolRibbonColor, 'Scatter', true);
set(h1321, 'SizeData', 30);
set(h18269, 'SizeData', 20);
set([h1321 h18269], 'MarkerFaceAlpha', 1, 'MarkerEdgeColor', 'none');
h18269.ZData(:) = ax.ZLim(2);
h1321.ZData(:) = ax.ZLim(2);

plot([195 205], [60 60], 'k', 'LineWidth', 1.5);
xlim([135 210]); ylim([60 120]);
set(findall(gcf, 'Type', 'patch'), 'FaceAlpha', 1);
tightfig(gcf);

if savePlots
    exportgraphics(gcf, fullfile(saveDir, 'Fig10C.png'), 'Resolution', 600);
end

%% Fig 10D -----------------------------------------------------------------

% Determine which bipolar synapses overlap with the parasol dendritic fields
ribbon1321 = c1321.getSynapseXYZ('RibbonPost');
df18269 = sbfsem.analysis.DendriticFieldHull(c18269, [], false);

tf18269 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df18269.data.hull(:,1), df18269.data.hull(:,2));
fprintf('%u of %u synapses were within the parasol dendritics field\n',...
    nnz(tf18269), size(ribbon1321, 1));

bcDist18269 = fastEuclid2d(...
    ribbon1321(tf18269, 1:2), df18269.data.centroid(1:2));

fprintf('c18269\t-\t'); printStat(bcDist18269, true);
fprintf('\t\tMinimum distance: %.2f\n', min(bcDist18269))


% Create the figure ----------------------------------------------------
% Add the neurons
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c18269'), 20);
set(findall(gcf, 'type', 'patch'), 'FaceAlpha', 1);
sb = plot3([180 200], [60 60], [0 0], 'k', 'LineWidth', 1.5);
xlim([96 201.5]); ylim([60 140]);

% Add the synapses
h1 = scatter3(ribbon1321(tf18269, 1), ribbon1321(tf18269, 2),...
    repmat(ax.ZLim(2), [nnz(tf18269), 1]),...
    35, bcDist18269, 'filled', 'MarkerEdgeColor', 'k');
% Set the color mapping
colormap(cmap);
b = colorbar('Location', 'southoutside');
b.Label.String = "Distance from Parasol Dendritic Field Center (microns)";
fprintf('Max distance: %.2f\n', max(bcDist18269));
set(ax, 'CLim', [0 35]);
xlim([160 235]-28); ylim([44, 105]+13);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig10D.png'), '-dpng', '-r600');
end

%% Data mentioned in the text
overlapBCs = ismember(T18269.NeuronID, T1321.NeuronID);
fprintf('%u of %u (%.2f%%) bipolar cells contacting the parasol RGC also contacted the smooth RGC\n',...
    nnz(overlapBCs), height(T18269), 100*nnz(overlapBCs)/height(T18269));