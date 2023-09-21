%% Figure 7
% - Last updated: 20Sep2023 SSP
% --

% Smooth RGCs
c1321 = Neuron(1321, 'i', true);
c1321.getLinks();
T1321 = getLinkedBipolarTypes(c1321);


% Parasol RGCs
c18269 = Neuron(18269, 'i', true);
c18269.getLinks();
T18269 = getLinkedBipolarTypes(c18269);

c5370 = Neuron(5370, 'i', true);
c5370.getLinks();
T5370 = getLinkedBipolarTypes(c5370);

%% Get the counts for each type of bipolar cell
linkTables = {T1321, T18269, T5370};
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