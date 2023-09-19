%% 20230912

c18269 = Neuron(18269, 'i');
c5063 = Neuron(5063, 'i');
c21392 = Neuron(21392, 'i');
c5370 = Neuron(5370, 'i');
c18269 = Neuron(18269, 'i');
c5035 = Neuron(5035, 'i');

%% Smooth RGC
c1321 = Neuron(1321, 'i', true);
% I split c1321 at the axon in Viking for this analysis and then merged the
% axon back once I was done.
x = sbfsem.analysis.DendriticFieldHull(c1321, [], false);
% Use area of a circle formula to get equivalent diameter
dfDiameter = 2*sqrt(x.data.hullArea / pi);
fprintf('Dendritic field diameter was %.3f\n', dfDiameter);
% Area = 2.059e4, Diameter = 161.913
% 57.315 +- 2.433 (n=5)

%% Parasol RGC
dfDiameters = zeros(1, 5);
x = sbfsem.analysis.DendriticFieldHull(c18269, [], false);
dfDiameter(1) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5063, [], false);
dfDiameter(2) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c21392, [], false);
dfDiameter(3) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5370, [], false);
dfDiameter(4) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5035, [], false);
dfDiameter(5) = 2*sqrt(x.data.hullArea / pi);
printStat(dfDiameter, "UseSD", true);


%% Nearest neighbor analysis
annotations = c1321.getCellNodes();
% Remove annotations likely to be the soma
somaRadius = c1321.getSomaSize(false);
annotations(2*annotations.Rum > 0.8*c1321.getSomaSize(false), :) = [];
dendrite1321 = annotations.XYZum;
% Remove annotations in axon area
%dendrite1321(dendrite1321(1,:) < 52 & dendrite1321(2,:) > 20, :) = [];
numAnnotations = size(dendrite1321, 1);

%% Synapse distances
ribbon1321 = c1321.getSynapseXYZ('RibbonPost');
numRibbons = size(ribbon1321, 1);
nearestBip = zeros(1, numRibbons);
for i = 1:numRibbons
    neighborDist = fastEuclid2d(ribbon1321(:, 1:2), ribbon1321(i, 1:2));
    neighborDist(i) = inf;  % Ignore self
    nearestBip(i) = min(neighborDist);
end

conv1321 = c1321.getSynapseXYZ('ConvPost');
numConv = size(conv1321, 1);
nearestConv = zeros(1, numConv);
for i = 1:numConv
    neighborDist = fastEuclid2d(conv1321(:, 1:2), conv1321(i, 1:2));
    neighborDist(i) = Inf;
    nearestConv(i) = min(neighborDist);
end

figure(); hold on;
hBC = histogram(nearestBip, 'Normalization', 'pdf',...
    'BinWidth', 0.25, 'BinLimits', [0 100],...
    'LineWidth', 1, 'EdgeColor', 'b', 'DisplayStyle', 'stairs');
hAC = histogram(nearestConv, 'Normalization', 'pdf',...
    'BinWidth', 0.25, 'BinLimits', [0 100],...
    'LineWidth', 1, 'EdgeColor', 'r', 'DisplayStyle', 'stairs');
xlim([0 30]);
figPos(gcf, 0.6, 0.6);

%% Shuffle synapses
% If ribbon synapses are clustered, nearest neighbor distance should be
% lower than if the synapses were randomly distributed along the dendrites
numIterations = 1000;
randNearestBip = [];
for i = 1:numIterations
% We'll do this 1000 times to get a truly random synapse distribution
    locations = zeros(numRibbons, 3);
    for j = 1:numRibbons
        % Get a random dendrite annotation and pretend synapse is there
        locations(j, :) = dendrite1321(randi(numAnnotations, 1), :);
    end
    % Get the nearest neighbors of the random synapse assignment
    randNearestNeighbor = zeros(1, numRibbons);
    for j = 1:numRibbons
        iDist = fastEuclid2d(locations, locations(j, :));
        iDist(j) = inf;  % Ignore self
        randNearestNeighbor(j) = min(iDist);
    end
    randNearestBip = cat(1, randNearestBip, randNearestNeighbor);
end
figure(); hold on;
scatter(dendrite1321(:,1), dendrite1321(:,2), 'k');
scatter(locations(:, 1), locations(:,2), 'r', 'filled');

figure(); hold on;
h1a = histogram(nearestBip, 'Normalization', 'cdf',...
    'BinWidth', 0.25, 'BinLimits', [0 100],...
    'LineWidth', 1, 'EdgeColor', 'b', 'DisplayStyle', 'stairs');
h1b = histogram(randNearestBip, 'Normalization', 'cdf',...
    'BinWidth', 0.25, 'BinLimits', [0 100], 'DisplayStyle', 'stairs',...
    'LineWidth', 1, 'EdgeColor', [0.5 0.5 0.5]);
xlabel('Nearest Bipolar Cell Distance (microns)');
ylabel('Cumulative Probability');
figPos(gcf, 0.6, 0.6);

% If amacrine synapses are clustered, nearest neighbor distance should be
% lower than if the synapses were randomly distributed along the dendrites
numIterations = 1000;
randNearestConv = [];
for i = 1:numIterations
% We'll do this 1000 times to get a truly random synapse distribution
    locations = zeros(numConv, 3);
    for j = 1:numConv
        % Get a random dendrite annotation and pretend synapse is there
        locations(j, :) = dendrite1321(randi(numAnnotations, 1), :);
    end
    % Get the nearest neighbors of the random synapse assignment
    randNearestNeighbor = zeros(1, numConv);
    for j = 1:numConv
        iDist = fastEuclid2d(locations, locations(j, :));
        iDist(j) = inf;  % Ignore self
        randNearestNeighbor(j) = min(iDist);
    end
    randNearestConv = cat(1, randNearestConv, randNearestNeighbor);
end

figure(); hold on;
h = histogram(nearestConv, 'Normalization', 'cdf',...
    'BinWidth', 0.15, 'BinLimits', [0 100],...
    'LineWidth', 1, 'EdgeColor', 'b', 'DisplayStyle', 'stairs');
h1 = histogram(randNearestConv, 'Normalization', 'cdf',...
    'BinWidth', 0.15, 'BinLimits', [0 100], 'DisplayStyle', 'stairs',...
    'LineWidth', 1, 'EdgeColor', [0.5 0.5 0.5]);
xlabel('Nearest Amacrine Cell Distance (microns)');
ylabel('Cumulative Probability');
figPos(gcf, 0.6, 0.6);