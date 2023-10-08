
%% Settings
saveDir = fullfile(getSmoothMonoRepoDir(), "main", "MixOfGaussianModel");
savePlots = true;

run('loadKeyRGCs.m');

db4Color = hex2rgb('be273e');
db5Color = hex2rgb('458ac2');
giantColor = hex2rgb('f3b026');
smoothColor = [0.15 0.15 0.15];

%% Data import
T1321 = getLinkedBipolarTypes(c1321);
idkIDs = T1321.NeuronID(T1321.Class == "Unclassified");
idx = c1321.links.SynapseType=="RibbonPost" & ...
    ~ismember(c1321.links.NeuronID, idkIDs);
% The XYZ coordinates of the classified ribbon synapses
xyData = c1321.links.SynapseXYZ(idx, 1:2);
% The associated neuron IDs for determining BC type
neuronIDs = c1321.links.NeuronID(idx);

%% Create the Gaussian Mixture Model
GMM = GaussianMixModel(xyData, 4);

%% Check other numbers of components to confirm that 4 was right
GMM.checkComponents();

%% Save the mode
save(fullfile(saveDir, 'GMM.mat'), 'GMM');

%% Make the table for extended data
fitTable = table((1:GMM.numComponents)',...
    GMM.Mean, squeeze(GMM.SD)', GMM.Model.ComponentProportion',...
    'VariableNames', ["Component", "Mean", "SD", "Weight"]);
disp(fitTable);

%% Make the contour plot with smooth RGC overlay
cObj = GMM.contourPlot(Neuron=c1321);
cObj.LevelList = 0.2:0.1:1;
colormap(lighten(slanCM('thermal-2', 10), 0.1));
set(gca, 'CLim', [0.1 0.9]);
plot3([215 235], [0 0], [0 0], 'k', 'LineWidth', 1.5);
axis([20 245 -5 175]);
tightfig(gcf);
if savePlots
    exportgraphics(gcf, fullfile(saveDir, "GMM_Contour.png"),...
        "Resolution", 600);
end
clear cObj


%% Cluster the classified ribbon synapses
GMM.cluster(Neuron=c1321, Threshold=0.99);


[~, centroids, semiAxes, rotAngles] = GMM.clusterInfo(Threshold=0.99);
% Identify synapses exceeding the threshold
clusterIDs = GMM.numComponents + ones(size(GMM.xyData, 1), 1);
ellipses = []; ellipseHandles = [];
for i = 1:GMM.numComponents
    iEllipse = images.roi.Ellipse(...
        "Center", centroids(i,:), "SemiAxes", semiAxes(i,:),...
        "RotationAngle", rotAngles(i));
    % Draw the ellipses too for a sanity check
    ellipses = cat(1, ellipses, iEllipse);
    ellipseHandles = cat(1, ellipseHandles,...
        drawellipse("Center", centroids(i,:),...
        "SemiAxes", semiAxes(i,:),...
        "RotationAngle", rotAngles(i)));
    % Find the synapses within the ellipse
    idx = inROI(ellipses(i), GMM.xyData(:,1), GMM.xyData(:,2));
    clusterIDs(idx) = i;
end


% Move the unclassified group to end to preserve color map
clusterIDs(clusterIDs == 0) = 5;

% Group stats on the clusters
[G, groupNames] = findgroups(clusterIDs);
N = splitapply(@numel, clusterIDs, G);
clusterTable = table(groupNames, N,...
    'VariableNames', ["Cluster", "Count"]);
disp(clusterTable);


%% Plot the clusters and ellipses
ax = axes('Parent', figure());
clusterColors = pmkmp(GMM.numComponents+2, "CubicYF");
% Add the data colored by cluster
gObj = gscatter(GMM.xyData(:,1), GMM.xyData(:,2), G);
for i = 1:GMM.numComponents
    gObj(i).MarkerEdgeColor = clusterColors(5-i,:);
end
set(gObj(end), "MarkerEdgeColor", [0.5 0.5 0.5]);
legend("off");
% Add the smooth RGC
[~, nObj] = golgi(c1321, "Color", smoothColor, "ax", ax);
set(nObj, "FaceAlpha", 1);
% Add the ellipses
pObj = [];
for i = 1:GMM.numComponents
    iPatch = plot_ellipse(semiAxes(i,1), semiAxes(i,2),...
        GMM.Mean(i,1), GMM.Mean(i,2), rotAngles(i),...
        lighten(clusterColors(5-i,:), 0.9), "LineWidth", 1,...
        "EdgeColor", lighten(clusterColors(5-i,:), 0.3),...
        "Tag", sprintf("Comp%u", i));
    pObj = cat(1, pObj, iPatch);
end
% Final formatting
plot3([215 235], [0 0], [0 0], 'k', 'LineWidth', 1.5);
axis([20 245 -5 175]);
axis tight equal off
tightfig(gcf);
if savePlots
    exportgraphics(ax, fullfile(saveDir, "GMM_Clustering.png"),...
        "Resolution", 600);
end

clear i iPatch

%% Get the bipolar cells within each cluster
bipolarTypes = ["DB5", "DB4", "Giant"];
numBCs = numel(bipolarTypes);

bcIDs = cell(1, GMM.numComponents);
for i = 1:GMM.numComponents
    bcIDs{i} = neuronIDs(clusterIDs == i);
end

bcClasses = cell(1, GMM.numComponents);
classMatrix = zeros(GMM.numComponents, numBCs);
for i = 1:GMM.numComponents
    iClass = repmat("", [numel(bcIDs{i}), 1]);
    for j = 1:numel(iClass)
        iClass(j) = T1321.Class(T1321.NeuronID == bcIDs{i}(j));
    end
    bcClasses{i} = iClass;

    for j = 1:numBCs
        classMatrix(i,j) = nnz(bcClasses{i} == bipolarTypes(j));
    end
end
clear i j iClass

% Sanity check bc that was messy
assert(isequal(clusterTable.Count(1:GMM.numComponents),...
    sum(classMatrix, 2)), "Disagreement between clusterTable and classMatrix");

% Compile into tables
classTable = array2table(classMatrix, "VariableNames", bipolarTypes);
pctTable = classTable ./ sum(classTable, 1) .* 100;

% Make some pie charts (decided to do stacked bar chart in Igor)
for i = 1:GMM.numComponents
    figure();
    labels = arrayfun(@(a,b) sprintf("%u (%.1f%%)", a, b),...
        classTable{i,:}, pctTable{i,:});
    p = pie(classTable{i,:}, labels);
    colormap([db5Color; db4Color; giantColor]);
    title(sprintf("Component %u (N = %u)", i, sum(classTable{i,:})));
    savefig(gcf, fullfile(saveDir, sprintf("GMM_Comp%u.fig",i)));
end
clear labels p i