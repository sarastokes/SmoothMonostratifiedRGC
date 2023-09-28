
loadKeyRGCs();

smoothRGCs = [c1321 c7889];
parasolRGCs = [c18269, c5370, c5063, c5035, c21392];

parasolAC = arrayfun(@(x) x.getSynapseN("ConvPost"), parasolRGCs(1:3));
parasolBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), parasolRGCs(1:3));

smoothAC = arrayfun(@(x) x.getSynapseN("ConvPost"), smoothRGCs);
smoothBC = arrayfun(@(x) x.getSynapseN("RibbonPost"), smoothRGCs);

printStat(parasolAC ./ (parasolAC+parasolBC), true);
% 0.464 +- 0.059 (n=3)
printStat(smoothAC ./ (smoothAC+smoothBC), true);
% 0.692 +- 0.107 (n=2)

% Fisher's exact test
T = table([mean(parasolBC), mean(parasolAC)]',...
    [mean(smoothBC), mean(smoothAC)]',...
    'RowNames', {'Parasol', 'Smooth'},...
    'VariableNames', {'Bipolar', 'Amacrine'});

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
% Extended