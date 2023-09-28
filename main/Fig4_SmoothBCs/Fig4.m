%% Figure 4
% Last updated figures: 21Sep2023 (A-C)
% --

saveDir = fullfile(getSmoothMonoRepoDir(), 'main', 'Fig4_SmoothBCs');
savePlots = true;

db4Color = hex2rgb('be273e');
db5Color = hex2rgb('458ac2');
midgetColor = hex2rgb('5eb672');
giantColor = hex2rgb('f3b026');

%%
c1321 = Neuron(1321, 'i', true);
c1321.getLinks();

T1321 = getLinkedBipolarTypes(c1321);

db4IDs = T1321{T1321.Class == "DB4", "NeuronID"};
db5IDs = T1321{T1321.Class == "DB5", "NeuronID"};
giantIDs = T1321{T1321.Class == "Giant", "NeuronID"};

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

if savePlots
    exportgraphics(ax, fullfile(saveDir, 'Fig4B.png'), "Resolution", 600);
end

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

if savePlots
    exportgraphics(ax, fullfile(saveDir, 'Fig4A.png'), "Resolution", 600);
end

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
    exportgraphics(ax1, fullfile(saveDir, 'Fig4A.png'), "Resolution", 600);
    exportgraphics(ax2, fullfile(saveDir, 'Fig4B.png'), "Resolution", 600);
    exportgraphics(ax3, fullfile(saveDir, 'Fig4C.png'), "Resolution", 600);
end

%% Density maps ()