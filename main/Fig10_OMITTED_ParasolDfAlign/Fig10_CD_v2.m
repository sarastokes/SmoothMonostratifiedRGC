%% Figure 10C-D
% - Last updated figure: 19Sep2023
% --

run('loadKeyRGCs.m');

mainColor = [0.15 0.15 0.15];
parasolColor = [0.6 0.6 0.6; 0.8 0.8 0.8];
giantColor = hex2rgb('f3c14a');
db4Color = hex2rgb('dc2a33');
db5Color = hex2rgb('5c99cc');
midgetColor = hex2rgb('7bbe88');
cmap = linspecer(11, 'sequential'); cmap(5,:) = [];

savePlots = true;
saveDir = fullfile(getSmoothMonoRepoDir(), "main", "Fig10_ParasolDfAlign");

% Determine which bipolar synapses overlap with the parasol dendritic fields
ribbon1321 = c1321.getSynapseXYZ('RibbonPost');
df5063 = sbfsem.analysis.DendriticFieldHull(c5063, [], false);
df18269 = sbfsem.analysis.DendriticFieldHull(c18269, [], false);
df5035 = sbfsem.analysis.DendriticFieldHull(c5035, [], false);

tf18269 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df18269.data.hull(:,1), df18269.data.hull(:,2));
tf5063 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df5063.data.hull(:,1), df5063.data.hull(:,2));
tf5035 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df5035.data.hull(:,1), df5035.data.hull(:,2));
fprintf('%u, %u and %u of %u synapses were within the parasol dendritics field\n',...
    nnz(tf18269), nnz(tf5063), nnz(tf5035), size(ribbon1321, 1));

bcDist5063 = fastEuclid2d(...
    ribbon1321(tf5063, 1:2), df5063.data.centroid(1:2));
bcDist18269 = fastEuclid2d(...
    ribbon1321(tf18269, 1:2), df18269.data.centroid(1:2));
bcDist5035 = fastEuclid2d(...
    ribbon1321(tf5035, 1:2), df5035.data.centroid(1:2));

fprintf('c18269\t-\t'); printStat(bcDist18269, true);
fprintf('\t\tMinimum distance: %.2f\n', min(bcDist18269))
fprintf('c5035\t-\t'); printStat(bcDist5035, true);
fprintf('\t\tMinimum distance: %.2f\n', min(bcDist5035))
fprintf('c5063\t-\t'); printStat(bcDist5063, true);
fprintf('\t\tMinimum distance: %.2f\n', min(bcDist5063))



% Repeat but for amacrine cells
amacrine1321 = c1321.getSynapseXYZ('ConvPost');
tf18269a = inpolygon(amacrine1321(:,1), amacrine1321(:,2),...
    df18269.data.hull(:,1), df18269.data.hull(:,2));
tf5063a = inpolygon(amacrine1321(:,1), amacrine1321(:,2),...
    df5063.data.hull(:,1), df5063.data.hull(:,2));
fprintf('%u of %u synapses were within the parasol dendritics field\n',...
    nnz(tf18269a | tf5063a), size(amacrine1321, 1));

acDist5063 = fastEuclid2d(amacrine1321(...
    tf5063a, 1:2), df5063.data.centroid(1:2));
acDist18269 = fastEuclid2d(...
    amacrine1321(tf18269a, 1:2), df18269.data.centroid(1:2));


%% Create the figure
% Add the neurons
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', parasolColor(2,:), 'ax', ax);
clipMesh(findByTag(ax, 'c18269'), 20);
golgi(c5063, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c5063'), 45);
golgi(c5035, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c5035'), 22);
set(findall(gcf, 'type', 'patch'), 'FaceAlpha', 1);
sb = plot3([180 200], [60 60], [0 0], 'k', 'LineWidth', 1.5);
xlim([96 201.5]); ylim([60 140]);

% Add the synapses
h2 = scatter3(ribbon1321(tf5063, 1), ribbon1321(tf5063, 2),...
    repmat(ax.ZLim(2), [nnz(tf5063), 1]),...
    35, bcDist5063, 'filled', 'MarkerEdgeColor', 'k');
h1 = scatter3(ribbon1321(tf18269, 1), ribbon1321(tf18269, 2),...
    repmat(ax.ZLim(2), [nnz(tf18269), 1]),...
    35, bcDist18269, 'filled', 'MarkerEdgeColor', 'k');
h3 = scatter3(ribbon1321(tf5035, 1), ribbon1321(tf5035, 2),...
    repmat(ax.ZLim(2), [nnz(tf5035), 1]),...
    35, bcDist5035, 'filled', 'MarkerEdgeColor', 'k');
% Set the color mapping
colormap(cmap);
b = colorbar('Location', 'southoutside');
b.Label.String = "Distance from Parasol Dendritic Field Center (microns)";
fprintf('Max distance: %.2f\n', max([bcDist5035; bcDist5063; bcDist18269]));
set(ax, 'CLim', [0 35]);

%% Individual figures
ax = golgi(c1321, 'Color', mainColor);
[~, h5035] = golgi(c5035, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(h5035, 22);
set(findall(gcf, 'Type', 'patch'), 'FaceAlpha', 1);
h3 = scatter3(ribbon1321(tf5035, 1), ribbon1321(tf5035, 2),...
    repmat(ax.ZLim(2), [nnz(tf5035), 1]),...
    35, bcDist5035, 'filled', 'MarkerEdgeColor', 'k');
h3.SizeData = 50;
xlim([160 235]);ylim([42, 105]);
% Set the color mapping
colormap(cmap);
b = colorbar('Location', 'southoutside');
b.Label.String = "Distance from Parasol Dendritic Field Center (microns)";
fprintf('Max distance: %.2f\n', max([bcDist5035; bcDist5063; bcDist18269]));
set(ax, 'CLim', [0 35]);


%% Fig 10C -----------------------------------------------------------------
h1.Visible = 'off';
if savePlots
    print(gcf, fullfile(saveDir, 'Fig9D.png'), '-dpng', '-r600');
end

%% Fig 10D -----------------------------------------------------------------
h1.Visible = 'on'; h2.Visible = 'off';
set(findByTag(ax, 'c18269'), 'FaceColor', parasolColor(2,:));
set(findByTag(ax, 'c5063'), 'FaceColor', parasolColor(1,:));
if savePlots
    print(gcf, fullfile(saveDir, 'Fig9C.png'), '-dpng', '-r600');
end

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
end
xlim([110 225]); ylim([54 130]);
clipMesh(findByTag(ax, 'c19331'), 70, false);
clipMesh(findByTag(ax, 'c22114'), 74, false);
clipMesh(findByTag(ax, 'c22149'), 72, false);
clipMesh(findByTag(ax, 'c22227'), 55, false);
clipMesh(findByTag(ax, 'c22260'), 70, false);
clipMesh(findByTag(ax, 'c22509'), 63.5, false);

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
    exportgraphics(gca, fullfile(saveDir, 'Fig9A_original.png'),...
        "Resolution", 600);
end


%% Fig 9B -----------------------------------------------------------------
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
    exportgraphics(gca, fullfile(saveDir, 'Fig9B_original.png'),...
        "Resolution", 600);
end

%% Data mentioned in the text
overlapBCs = ismember(T18269.NeuronID, T1321.NeuronID);
fprintf('%u of %u (%.2f%%) bipolar cells contacting the parasol RGC also contacted the smooth RGC\n',...
    nnz(overlapBCs), height(T18269), 100*nnz(overlapBCs)/height(T18269));