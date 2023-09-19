

c1321 = Neuron(1321, 'i', true);
c1321.getLinks();
T1321 = getLinkedBipolarTypes(c1321);
T18269 = getLinkedBipolarTypes(c18269);
%%



binEdges = [1 2 4 7 10 14 30];
numBins = numel(binEdges) - 1;
bcTypes = ["DB4", "DB5", "DB6", "Giant", "Midget"];
numBCs = numel(bcTypes);
binMat = zeros(numBins+1, numBCs);

for i = 2:numel(binEdges)
    for j = 1:numBCs
        N = nnz(T.Class == bcTypes(j) & T.Count <= binEdges(i));
        N = N - sum(binMat(1:i-1, j));
        binMat(i, j) = N;
    end
end
binMat(1,:) = [];

