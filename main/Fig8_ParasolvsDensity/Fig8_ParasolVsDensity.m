

c1321 = Neuron(1321, 'i', true);
c5035 = Neuron(5035, 'i');
c18269 = Neuron(18269, 'i');
c5063 = Neuron(5063, 'i');

%% Testing fig 10
[hR, hA] = scatterIE(c1321, bins=23, smoothFac=1,...
    markers=false, dendrite=true, square=true,...
    cmap=lighten(slanCM('thermal-2'), 0.2), branch=false);
hR = hR(1);

figure(); hold on;
hR = surf(hR.XData, hR.YData, hR.ZData, hR.CData,...
    'EdgeColor', 'none', 'FaceColor', 'interp',...
    'FaceLighting', 'phong');
colormap(lighten(slanCM('thermal-2'), 0.1));
axis equal tight;
view(0,90);
xBound = xlim(); yBound = ylim();
plot3(gca, [215 235], [-15 -15], [50 50], 'w', 'LineWidth', 1);

[~, h18269] = golgi(c18269, 'ax', gca, 'FaceColor', 'k');
h18269.FaceAlpha = 1;
clipMesh(h18269, 20, true);
[~, h5063] = golgi(c5063, 'ax', gca, 'FaceColor', 'k');
c5063.FaceAlpha = 1;
clipMesh(h5063, 40, true);

[~, h5035] = golgi(c5035, 'ax', gca, 'FaceColor', 'k');
h5035.FaceAlpha = 1;
clipMesh(h5035, 26, true);
%clipMesh2(gco, 'X', @(x) x < 195, 'Z', @(x) x< 42);

set(findall(gcf, 'Type', 'patch'), 'FaceAlpha', 1);

if savePlots
    exportgraphics(gca, fullfile(saveDir, 'Fig10_S1.png'), "Resolution", 600);
end

%% Colorbar
% Copy into Illustrator to alter the text etc. Both horizontal and vertical
% to see which fits the layout better
figure();
tiledlayout(1,1);
hideAxes();

cb1 = colorbar('Location', 'eastoutside');
cb1.Label.String = 'Normalized Synapse/Dendrite Density';

cb2 = colorbar('Location', 'southoutside');
cb1.Label.String = 'Normalized Synapse/Dendrite Density';

colormap(lighten(slanCM('thermal-2'), 0.1));