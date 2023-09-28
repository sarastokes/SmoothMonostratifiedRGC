%% Figure 7
% - Last updated: 20Sep2023 SSP
% --

% Smooth RGCs
c1321 = Neuron(1321, 'i', true); c1321.getLinks();

% Parasol RGCs
c18269 = Neuron(18269, 'i', true); c18269.getLinks();
c5370 = Neuron(5370, 'i', true); c5370.getLinks();
c5063 = Neuron(5063, 'i', true); c5063.getLinks();

%% Get the counts for each type of bipolar cell
T1321 = getLinkedBipolarTypes(c1321);
T5063 = getLinkedBipolarTypes(c5063);
T5370 = getLinkedBipolarTypes(c5370);
T18269 = getLinkedBipolarTypes(c18269);
linkTables = {T1321, T18269, T5063, T5370};
numNeurons = numel(linkTables);

binEdges = [1 2 4 7 10 14 30];
numBins = numel(binEdges) - 1;
bcTypes = ["DB4", "DB5", "DB6", "Giant", "Midget"];
numBCs = numel(bcTypes);

binMat = zeros(numNeurons, numBins+1, numBCs);

for k = 1:numNeurons
    T = linkTables{k};
    for i = 2:numel(binEdges)
        for j = 1:numBCs
            N = nnz(T.Class == bcTypes(j) & T.Count <= binEdges(i));
            N = N - sum(binMat(k, 1:i-1, j));
            binMat(k, i, j) = N;
        end
    end
end
binMat(:, 1, :) = [];

smoothSampling = squeeze(binMat(1,:,:));
smoothSampling = 100 * smoothSampling / sum(smoothSampling(:));
parasolSampling = squeeze(sum(binMat(2:end,:,:), 1));
parasolSampling = 100 * parasolSampling/sum(parasolSampling(:));

% I moved the data to Igor to make the plot.


%% Extended Data Tables 8-1 through 8-4
T81 = array2table(...
    [squeeze(binMat(1,:,:)), sum(squeeze(binMat(1,:,:)), 2)],...
    'VariableNames', [bcTypes, "Total"],...
    "RowNames", {'1-2', '3-4', '5-7', '8-10', '11-14', '15+'});

T82 = array2table(...
    [squeeze(binMat(4,:,:)), sum(squeeze(binMat(4,:,:)), 2)],...
    'VariableNames', [bcTypes, "Total"],...
    "RowNames", {'1-2', '3-4', '5-7', '8-10', '11-14', '15+'});

T83 = array2table(...
    [squeeze(binMat(2,:,:)), sum(squeeze(binMat(2,:,:)), 2)],...
    'VariableNames', [bcTypes, "Total"],...
    "RowNames", {'1-2', '3-4', '5-7', '8-10', '11-14', '15+'});


T84 = array2table(...
    [squeeze(binMat(3,:,:)), sum(squeeze(binMat(3,:,:)), 2)],...
    'VariableNames', [bcTypes, "Total"],...
    "RowNames", {'1-2', '3-4', '5-7', '8-10', '11-14', '15+'});