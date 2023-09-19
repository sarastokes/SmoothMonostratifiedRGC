%% Figure 1
% - Figures last updated: 20230912 (SSP)
% --

savePlots = true;
saveDir = 'C:\Users\spatterson\Dropbox\Sara and Jay Shared\smooth monostratified ganglion cells';

%% Import
c1321 = Neuron(1321, 'i');
c5370 = Neuron(5370, 'i');

%% Fig1A ------------------------------------------------------------------
c1321.render('FaceColor', [0.3 0.3 0.3]);
c5370.render('FaceColor', [0.6 0.6 0.6], 'FaceAlpha', 0.8, 'ax', gca);
view(0, 90);
hideAxes();
sb = plot3([215 235], [1 1], [0 0], 'k', 'LineWidth', 1.5);
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig1A.png'), '-dpng');
end

%% Fig 1B -----------------------------------------------------------------
c1321.render('FaceColor', [0.3 0.3 0.3]);
c5370.render('FaceColor', [0.6 0.6 0.6], 'FaceAlpha', 0.8, 'ax', gca);
view(0,0);
flattenRender(findByTag(gcf, 'c1321'), 'i');
flattenRender(findByTag(gcf, 'c5370'), 'i');
view(83,0);
% Make vertical scale bar so the sizing is right.
sb = plot3([210 210], [200 200], [40 60], 'k', 'LineWidth', 1.5);
hideAxes();
tightfig(gcf);
if savePlots
    print(gcf, fullfile(saveDir, 'Fig1B.png'), '-dpng', '-r600');
end
% Once I get in illustrator I make a line that matches the vertical
% scale bar, rotate it (or copy the image and crop it to just include
% the scale bar. Then I cover up the original with a white box.
% I group the pic and line after so that they will resize together
% and never end up out of sync, which is the big thing to watch for
% when using this method.