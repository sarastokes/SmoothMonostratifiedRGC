
run('loadKeyRGCs.m');
c51063 = Neuron(51063, 'i');
db4Color = hex2rgb('dc2a33');


[ax, hBC] = golgi(c51063, 'Color', db4Color);
golgi(c1321, 'ax', ax, 'Color', [0 0 0]);
set(findall(ax, 'Type', 'patch'), 'FaceAlpha', 1);
xlim([83 110]); ylim([5 40]);
scaleBar = plot3(ax, [83 88], [6 6], [50 50], 'k', 'LineWidth', 1.5);
tightfig(gcf);
exportgraphics(ax, 'FigS2_branchzoom.png', "Resolution", 600);

axis tight;
delete(scaleBar);
plot3(ax, [215 235]-5, [0 0], [50 50], 'k', 'LineWidth', 1.5);
exportgraphics(ax, 'FigS2_fulldf.png', "Resolution", 600);