%% Figure 9
% - Last updated: 17Sep2023 SSP
% --
c1321 = Neuron(1321, 'i', true);
c18269 = Neuron(18269, 'i', true);
c5063 = Neuron(5063, 'i', true);
c19331 = Neuron(19331, 'i');

mainColor = [0.15 0.15 0.15];
parasolColor = [0.6 0.6 0.6; 0.8 0.8 0.8];
ribbonColor = rgb('carolina blue');%rgb('sky blue');
bipolarColor = hex2rgb('E71D36');
parasolRibbonColor = [hex2rgb('00cc4d'); rgb('emerald')];
smoothRibbonColor = lighten(rgb('cerulean'), 0.3);
% #E71D36 #00cc4d #1AAA5B #3772ff #FFD447


%% Fig 9A
ax = golgi(c1321, 'Color', mainColor);
golgi(c5063, 'Color', parasolColor(2,:), 'ax', ax);
clipMesh(findByTag(ax, 'c5063'), 45);
golgi(c18269, 'Color', parasolColor(1,:), 'ax', ax);
clipMesh(findByTag(ax, 'c18269'), 20);
golgi(c5035, 'Color', parasolColor(2,:), 'ax', ax);
clipMesh(findByTag(ax, 'c5035'), 25);
set(findall(ax, 'type', 'patch'), 'FaceAlpha', 1);
plot3([215 235], [1 1], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);

% Ribbon synapses
h1321 = mark3D(c1321.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', ribbonColor, 'Scatter', true);
h18269 = mark3D(c18269.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color',parasolRibbonColor(1, :), 'Scatter', true);
h5063 = mark3D(c5063.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', parasolRibbonColor(2,:), 'Scatter', true);
h5035 = mark3D(c5035.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', parasolRibbonColor(2,:), 'Scatter', true);
h5035 = mark3D(c5035.getSynapseXYZ('RibbonPost'),...
    'ax', ax, 'Color', parasolRibbonColor(2,:), 'Scatter', true);
set(h1321, 'SizeData', 10);
set(h18269, 'SizeData', 5);
h18269.ZData(:) = ax.ZLim(2);
h1321.ZData(:) = ax.ZLim(2);
h5035.ZData(:) = ax.ZLim(2);
h5063.ZData(:) = ax.ZLim(2);
h1321.ZData(:) = ax.ZLim(2);
if savePlots
    exportgraphics(gcf, fullfile(saveDir, 'Fig9A_v2.png'), 'Resolution', 600);
end

% Continue modifying this figure to create B and C

%% Figure 9C
set(findByTag(ax, 'c5035'), 'Visible', 'off');
set(findByTag(ax, 'c5063'), 'Visible', 'off');
%h5063.Visible = 'off';
xlim([135 210]); ylim([60 120]);
h1321.SizeData = 30;
h18269.SizeData = 20;
h18269.ZData = h18269.ZData -1;
plot([189 209], [60 60], 'k', 'LineWidth', 1.5);

ribbon19331 = c18269.links{...
    c18269.links.SynapseType == "RibbonPost" & ...
    c18269.links.NeuronID == 19331, 'SynapseXYZ'};
h19331 = mark3D(ribbon19331,...
    'ax', ax, 'Color', hex2rgb('E71D36'), 'Scatter', true);
h19331.ZData = ax.ZLim(2) + zeros(size(h19331.YData));
h19331.SizeData = 20;
h19331.MarkerEdgeColor = 'none';
if savePlots
    exportgraphics(gcf, fullfile(saveDir, 'Fig9C.png'), 'Resolution', 600);
end


c5063.links{...
    c5063.links.SynapseType == "RibbonPost" & ...
    c5063.links.NeuronID == 19331, "SynapseXYZ"};

%% Figure 9B
h19331.Visible = 'off';
h1321.Visible = 'off';
h18269.Visible = 'off';
golgi(c19331, 'ax', ax, 'FaceColor', hex2rgb('e71d36'));
set(findobj(gcf, 'Tag', 'c19331'), 'FaceAlpha', 1);
xlim([135 210]); ylim([60 120]);
print(gcf, fullfile(saveDir, 'Fig10C.png'), '-dpng', '-r600');
if savePlots
    exportgraphics(gcf, fullfile(saveDir, 'Fig9B.png'), 'Resolution', 600);
end