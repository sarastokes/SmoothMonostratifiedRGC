
T = countLinkedNeurons(c1321, 'RibbonPost');
T.Label = repmat("", [height(T), 1]);
for i = 1:height(T)
    T.Label(i) = unique(c1321.links{c1321.links.NeuronID == T.NeuronID(i), 'NeuronLabel'});
end

T.Class = repmat("", [height(T), 1]);
T.Class(contains(T.Label, 'DB4')) = "DB4";
T.Class(contains(T.Label, 'DB5')) = "DB5";
T.Class(contains(T.Label, 'Giant', 'IgnoreCase', true)) = "Giant";
T.Class(T.NeuronID == 22524) = "DB5";

db5XYZ = c1321.links{ismember(c1321.links.NeuronID, T.NeuronID(T.Class == "DB5")), 'SynapseXYZ'};
db4XYZ = c1321.links{ismember(c1321.links.NeuronID, T.NeuronID(T.Class == "DB4")), 'SynapseXYZ'};
giantXYZ = c1321.links{ismember(c1321.links.NeuronID, T.NeuronID(T.Class == "Giant")), 'SynapseXYZ'};
idkXYZ = c1321.links{ismember(c1321.links.NeuronID, T.NeuronID(T.Class == "")), 'SynapseXYZ'};


ax = golgi(c1321, 'Color', [0.15, 0.15, 0.15]);
set(findByTag(ax, 'c1321'), 'FaceAlpha', 1);
sb = plot3([180 200], [60 60], [0 0], 'k', 'LineWidth', 1.5);

hU = mark3D(idkXYZ, 'ax', ax, 'Color', [0.7 0.7 0.7], 'Scatter', true);
hG = mark3D(giantXYZ, 'ax', ax, 'Color', rgb('peach'), 'Scatter', true);
h5 = mark3D(db5XYZ, 'ax', ax, 'Color', hex2rgb('3772ff'), 'Scatter', true);
h4 = mark3D(db4XYZ, 'ax', ax, 'Color', [1 0.25 0.25], 'Scatter', true);
set([hU, hG, h5, h4], 'MarkerFaceAlpha', 0.8);

