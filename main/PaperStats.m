
loadKeyRGCs();

smoothRGCs = [c1321 c7889];
parasolRGCs = [c18269, c5370, c5063, c5035, c21392];

T1321 = getLinkedBipolarTypes(c1321);
T18269 = getLinkedBipolarTypes(c18269);
T5370 = getLinkedBipolarTypes(c5370);
T5063 = getLinkedBipolarTypes(c5063);

parasolTable = [T18269; T5370; T5063];  % For group analysis

%% Synaptic input to parasol and smooth RGCs from bipolar and amacrine cells
parasolAC = arrayfun(@(x) x.getSynapseN("ConvPost"), parasolRGCs(1:3));
parasolBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), parasolRGCs(1:3));

smoothAC = arrayfun(@(x) x.getSynapseN("ConvPost"), c1321);
smoothBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), c1321);

printStat(parasolAC ./ (parasolAC+parasolBC), true);
% 0.464 +- 0.059 (n=3)
printStat(smoothAC ./ (smoothAC+smoothBC), true);
% 0.692 +- 0.107 (n=2)

parasolTotal = parasolAC + parasolBC;
printStat(parasolTotal, true);
parasolTotal = mean(parasolTotal);

smoothTotal = smoothAC + smoothBC;
printStat(smoothTotal, true);
smoothTotal = mean(smoothTotal);

disp(parasolTotal / smoothTotal)
disp(smoothTotal / parasolTotal)

fprintf('Parasol RGCs received %.2f%% times as much bipolar cell input as smooth RGCs\n', mean(parasolBC) / mean(smoothBC));
fprintf('Parasol RGCs received %.2f%% times as much amacrine cell input as smooth RGCs\n', mean(parasolAC) / mean(smoothAC));
fprintf('Parasol RGCs received %.2f%% times as much synaptic input as smooth RGCs\n', mean(parasolTotal) / mean(smoothTotal));
% Parasol RGCs received 1.48% times as much bipolar cell input as smooth RGCs
% Parasol RGCs received 0.78% times as much amacrine cell input as smooth RGCs
% Parasol RGCs received 1.05% times as much synaptic input as smooth RGCs

%% Bipolar cell classification
% How many bipolar cell synapses onto parasol RGCs were classified?
numClassified = sum(parasolTable.Count(parasolTable.Class ~= "Unclassified"));
numTotal = sum(parasolTable.Count);
fprintf('%u of %u parasol synapses were classified (%.2f%%)\n',...
    numClassified, numTotal, numClassified / numTotal * 100);

% How many bipolar cell synapses onto the smooth RGC were classified
numClassified = sum(T1321.Count(T1321.Class ~= "Unclassified"));
numTotal = sum(T1321.Count);
fprintf('%u of %u smooth synapses were classified (%.2f%%)\n',...
    numClassified, numTotal, numClassified / numTotal * 100);
% 117 of 126 smooth synapses were classified (92.86%)

%% Sampling density
% Smooth RGCs get less ribbon synapses but have more presynaptic bipolar cells
allParasol = {T5370; T18269; T5063};

parasolSyn = cellfun(@(x) sum(x.Count), allParasol);
printStat(parasolSyn, true); % 186.333 +- 39.514 (n=3)
parasolBC = cellfun(@(x) height(x), allParasol);
printStat(parasolBC, true); % 40.667 +- 3.055 (n=3)

fprintf('1321, Bipolar cells: %u, Synapses: %u\n', height(T1321), sum(T1321.Count));

% How many of c1321's classified bipolar cells provide 1-2 synapses?
classifiedSmooth = T1321(T1321.Class ~= "Unclassified",:);

smoothBipolar12 = 100*nnz(classifiedSmooth.Count <= 2) / height(classifiedSmooth);
fprintf('%.2f%% of %u presynaptic bipolar cells provided 1-2 synapses to smooth RGC\n', smoothBipolar12, height(classifiedSmooth));
% 77.78%

% Percent of presynaptic bipolar cells that provide 1-2 synapses to
% the three parasol RGCs
classifiedParasols = {...
    T18269(T18269.Class ~= "Unclassified",:);...
    T5370(T5370.Class ~= "Unclassified",:);...
    T5063(T5063.Class ~= "Unclassified",:)};
bcWith12Synapses = 100*sum(cellfun(@(x) nnz(x.Count <= 2), classifiedParasols)) / ...
    sum(cellfun(@(x) height(x), classifiedParasols));
fprintf('%.2f%% of presynaptic bipolar cells provided 1-2 synapses to parasol RGC\n', bcWith12Synapses);
%  40.71%
%% Relationship between parasol RGCs and bipolar cell input to smooth RGCs

% How many presynaptic bipolar cells for c18269 also synapse on c1321?
overlapIDs = T18269.NeuronID(ismember(T18269.NeuronID, T1321.NeuronID));
overlapTypes = T18269.Class(ismember(T18269.NeuronID, T1321.NeuronID));
fprintf('%u of %u presynaptic bipolar cells\n',...
    nnz(ismember(T18269.NeuronID, T1321.NeuronID)),...
    numel(T18269.NeuronID));
% 11 of 44

% How many DB4, DB5 and giant bipolar cells synapsed on both RGCs
fprintf('%u of %u DB4 bipolar cells\n',...
    nnz(overlapTypes == "DB4"), nnz(T1321.Class == "DB4"));
fprintf('%u of %u DB5 bipolar cells\n',...
    nnz(overlapTypes == "DB5"), nnz(T1321.Class == "DB5"));
fprintf('%u of %u giant bipolar cells\n',...
    nnz(overlapTypes == "Giant"), nnz(T1321.Class == "Giant"));


% How many synapses did c18269 receive from DB4 bipolar 19331?
fprintf('%u synapses from c19331\n', T18269.Count(T18269.NeuronID == 19331));
% 33

%% Discussion
% Were DB5 BCs the dominant driver of the BC clusters?
disp([10/21 23/30 8/14 15/18]*100)  % ranging from 48-83%