%% Figure 10 (A and B)
% - Last updated figure: 19Sep2023
% --

c1321 = Neuron(1321, 'i', true);
c1321.getLinks();
c18269 = Neuron(18269, 'i', true);
c18269.getLinks();
c5063 = Neuron(5063, 'i', true);
c5063.getLinks();

mainColor = [0.15 0.15 0.15];
parasolColor = [0.6 0.6 0.6; 0.8, 0.8, 0.8];
cmap = linspecer(11, 'sequential'); cmap(5,:) = [];

savePlots = true;
saveDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells';

% Determine which bipolar synapses overlap with the parasol dendritic fields
ribbon1321 = c1321.getSynapseXYZ('RibbonPost');
df5063 = sbfsem.analysis.DendriticFieldHull(c5063, [], false);
df18269 = sbfsem.analysis.DendriticFieldHull(c18269, [], false);

tf18269 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df18269.data.hull(:,1), df18269.data.hull(:,2));
tf5063 = inpolygon(ribbon1321(:,1), ribbon1321(:,2),...
    df5063.data.hull(:,1), df5063.data.hull(:,2));
fprintf('%u of %u synapses were within the parasol dendritics field\n',...
    nnz(tf18269 | tf5063), size(ribbon1321, 1));

bcDist5063 = fastEuclid2d(...
    ribbon1321(tf5063, 1:2), df5063.data.centroid(1:2));
bcDist18269 = fastEuclid2d(...
    ribbon1321(tf18269, 1:2), df18269.data.centroid(1:2));


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
golgi(c18269, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c18269'), 20);
golgi(c5063, 'Color', parasolColor(2,:), 'ax', ax);
clipMesh(findByTag(ax, 'c5063'), 45);
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
% Set the color mapping
colormap(cmap);
b = colorbar('Location', 'southoutside');
b.Label.String = "Distance from Parasol Dendritic Field Center (microns)";
set(ax, 'CLim', [0 35]);


%% Fig 9C -----------------------------------------------------------------
h1.Visible = 'off';
if savePlots
    print(gcf, fullfile(saveDir, 'Fig9D.png'), '-dpng', '-r600');
end

%% Fig 9D -----------------------------------------------------------------
h1.Visible = 'on'; h2.Visible = 'off';
set(findByTag(ax, 'c18269'), 'FaceColor', parasolColor(2,:));
set(findByTag(ax, 'c5063'), 'FaceColor', parasolColor(1,:));
if savePlots
    print(gcf, fullfile(saveDir, 'Fig9C.png'), '-dpng', '-r600');
end

%% Fig 9B
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', [0.5 0.5 0.5], 'ax', ax);
golgi(c5063, 'Color', [0.5 0.5 0.5], 'ax', ax);
clipMesh(findobj(gcf, 'Tag', 'c18269'), 20, true);
clipMesh(findobj(gcf, 'Tag', 'c5063'), 40, true);
xlim([110 220]); ylim([50 118])
drawnow;

% Add all the DB5 bipolar cells
db4s = unique(c18269.links{...
    c18269.links.SynapseType == "RibbonPost" & ...
    contains(c18269.links.NeuronLabel, 'DB4'), 'NeuronID'});
for i = 1:numel(db4s)
    golgi(Neuron(db4s(i), 'i'), 'Color', rgb('light red'), 'ax', ax);
end
clipMesh(findByTag(ax, 'c19331'), 70, false);
clipMesh(findByTag(ax, 'c22114'), 74, false);
clipMesh(findByTag(ax, 'c22149'), 72, false);
clipMesh(findByTag(ax, 'c22227'), 55, false);
clipMesh(findByTag(ax, 'c22260'), 70, false);
clipMesh(findByTag(ax, 'c22509'), 63.5, false); % check

% Highlight the ones that contact the smooth RGC
smoothDB4 = db4s(ismember(db4s, c1321.links{...
    c1321.links.SynapseType == "RibbonPost", "NeuronID"}));
for i = 1:numel(smoothDB4)
    set(findobj(ax, 'Tag', ['c', num2str(smoothDB4(i))]),...
        'FaceColor', lighten(rgb('light red'), 0.5));
end

set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
xlim([110 220]); ylim([50 118])
plot3([198 218], [51 51], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);


%% Fig 9B -----------------------------------------------------------------
% Render the neurons, cut the axons for the parasols
ax = golgi(c1321, 'Color', mainColor);
golgi(c18269, 'Color', [0.5 0.5 0.5], 'ax', ax);
golgi(c5063, 'Color', [0.5 0.5 0.5], 'ax', ax);
clipMesh(findobj(gcf, 'Tag', 'c18269'), 20, true);
clipMesh(findobj(gcf, 'Tag', 'c5063'), 40, true);
xlim([110 220]); ylim([50 118])
drawnow;

% Add the DB5 bipolar cells
db5s = unique(c18269.links{...
    c18269.links.SynapseType == "RibbonPost" & ...
    contains(c18269.links.NeuronLabel, 'DB5'), 'NeuronID'});
for i = 1:numel(db5s)
    golgi(Neuron(db5s(i), 'i'), 'Color', rgb('bright blue'), 'ax', ax);
    drawnow;
end
smoothDB5 = db5s(ismember(db5s, c1321.links{...
    c1321.links.SynapseType == "RibbonPost", "NeuronID"}));
for i = 1:numel(smoothDB5)
    set(findobj(ax, 'Tag', ['c', num2str(smoothDB5(i))]),...
        'FaceColor', rgb('sky blue'));
end
clipMesh(findByTag(ax, 'c21399'), 70, false);
clipMesh(findByTag(ax, 'c22138'), 68, false);
clipMesh(findByTag(ax, 'c22138'), 67, false);
clipMesh(findByTag(ax, 'c22138'), 64, false);
clipMesh(findByTag(ax, 'c22491'), 60, false);
clipMesh(findByTag(ax, 'c22679'), 57, false);
clipMesh(findByTag(ax, 'c23833'), 58, false);
clipMesh(findByTag(ax, 'c29644'), 56, false);

% Add in c5063's DB5 bipolar cells
db5_c5063 = unique(c5063.links{...
    c5063.links.SynapseType == "RibbonPost" & ...
    contains(c5063.links.NeuronLabel, 'DB5'), 'NeuronID'});
% Only need the ones that weren't contacting c18269
db5_c5063 = setdiff(db5_c5063, db5s);
for i = 1:numel(db5_c5063)
    golgi(Neuron(db5_c5063,  'i'),...
        'Color', rgb('bright blue'), 'ax', ax);
    drawnow;
end
smoothDB5_c5063 = db5_c5063(ismember(db5_c5063, c1321.links{...
    c1321.links.SynapseType == "RibbonPost", "NeuronID"}));
for i = 1:numel(smoothDB5_c5063)
    set(findobj(ax, 'Tag', ['c', num2str(smoothDB5_c5063(i))]),...
        'FaceColor', rgb('sky blue'));
end
clipMesh(findByTag(ax, 'c21399'), 70, false);

% Final formatting
set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
xlim([80 220]); ylim([50 150])
plot3([198 218], [51 51], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);
