
loadKeyRGCs();

smoothRGCs = [c1321 c7889];
parasolRGCs = [c18269, c5370, c5063, c5035, c21392];

T1321 = getLinkedBipolarCells(c1321);
T18269 = getLinkedBipolarCells(c18269);


%% Synaptic input to parasol and smooth RGCs from bipolar and amacrine cells
parasolAC = arrayfun(@(x) x.getSynapseN("ConvPost"), parasolRGCs(1:3));
parasolBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), parasolRGCs(1:3));

smoothAC = arrayfun(@(x) x.getSynapseN("ConvPost"), smoothRGCs);
smoothBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), smoothRGCs);

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


%% Sampling density
% Smooth RGCs get less ribbon synapses but have more presynaptic bipolar cells
T1321 = getLinkedBipolarTypes(c1321);
T5370 = getLinkedBipolarTypes(c5370);
T18269 = getLinkedBipolarTypes(c18269);
T5063 = getLinkedBipolarTypes(c5063);
allParasol = {T5370; T18269; T5063};

parasolSyn = cellfun(@(x) sum(x.Count), allParasol);
printStat(parasolSyn, true); % 186 +- 38.974 (n=3)
parasolBC = cellfun(@(x) height(x), allParasol);
printStat(parasolBC, true); % 41.333 +- 4.163 (n=3)

fprintf('1321, Bipolar cells: %u, Synapses: %u\n', height(T1321), sum(T1321.Count));



%% Relationship between parasol RGCs and bipolar cell input to smooth RGCs

% How many presynaptic bipolar cells for c18269 also synapse on c1321?
fprintf('%u of %u presynaptic bipolar cells\n',...
    nnz(ismember(T18269.NeuronID, T1321.NeuronID)),...
    numel(T18269.NeuronID));
% 11 of 46

% How many synapses did c18269 receive from DB4 bipolar 19331?
fprintf('%u synapses from c19331\n', T18269.Count(T18269.NeuronID == 19331));
% 30