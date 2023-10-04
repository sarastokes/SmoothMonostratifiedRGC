%% Figure 5
% - Last updated: 21Sep2023 SSP
% --


db4Color = hex2rgb('be273e');
db5Color = hex2rgb('458ac2');
midgetColor = hex2rgb('5eb672');
giantColor = hex2rgb('f3b026');
db6Color = [0.6 0.6 0.6];

run('loadKeyRGCs.m')
T1321 = getLinkedBipolarTypes(c1321);
T18269 = getLinkedBipolarTypes(c18269);
T5370 = getLinkedBipolarTypes(c5370);
T5063 = getLinkedBipolarTypes(c5063);

%% Figure 5A
[G, groupNames] = findgroups(T1321.Class);
counts = splitapply(@sum, T1321.Count, G);
bcSmooth = table(groupNames, counts,...
    'VariableNames', ["BipolarType", "Count"]);
bcSmooth = sortrows(bcSmooth, "Count", "descend");

% Print out info for the figure legend
idx = bcSmooth.BipolarType == "Unclassified";
fprintf('Unclassified for fig legend: %.1f%% (%u of %u)\n',...
    bcSmooth.Count(idx)/sum(bcSmooth.Count)*100,...
    bcSmooth.Count(idx), sum(bcSmooth.Count));
fprintf('Total synapses: %u\n', sum(bcSmooth.Count));
% N = 126, Unclassified = 7.1%

% Create the labels
pctValues = round(100*bcSmooth.Count/sum(bcSmooth.Count), 1);
labels = arrayfun(@(a,b) sprintf("%s\n(%.1f%%)", a, b),...
    bcSmooth.BipolarType, pctValues);

% Make the figure
figure();
p = pie(pctValues(~idx)/100, labels(~idx));

set(findall(p, 'Type', 'text'),...
    'FontName', 'Arial', 'FontSize', 8,...
    'HorizontalAlignment', 'center');
set(findall(p, 'Type', 'patch'), 'LineWidth', 1.5);

colormap([db4Color; db5Color; giantColor]);


%% Extended Data Table 5-1
perSmoothSynapses = splitapply(@sum, T1321.Count, G);
perSmoothNeurons = splitapply(@numel, T1321.Count, G);


%% Figure 5B
[G, groupNames] = findgroups([T18269.Class; T5370.Class; T5063.Class]);
counts = splitapply(@sum, [T18269.Count; T5370.Count; T5063.Count], G);
bcParasol = table(groupNames, counts,...
    'VariableNames', ["BipolarType", "Count"]);
bcParasol = sortrows(bcParasol, "Count", "descend");

% Print out info for the figure legend and text
idx = bcParasol.BipolarType == "Unclassified";
fprintf('Unclassified synapses: %.1f%% (%u of %u)\n',...
    bcParasol.Count(idx)/sum(bcParasol.Count)*100,...
    bcParasol.Count(idx), sum(bcParasol.Count));
fprintf('Total synapses: %u\n', sum(bcParasol.Count));

% Create the labels
pctValues = round(100*bcParasol.Count/sum(bcParasol.Count), 1);
labels = arrayfun(@(a,b) sprintf("%s\n(%.1f%%)", a, b),...
    bcParasol.BipolarType, pctValues);

% Make the figure
figure();
p = pie(pctValues(~idx)/100, labels(~idx));
set(findall(p, 'Type', 'text'),...
    'FontName', 'Arial', 'FontSize', 8,...
    'HorizontalAlignment', 'center');
set(findall(p, 'Type', 'patch'), 'LineWidth', 1.5);
colormap([db4Color; db5Color; midgetColor; giantColor; db6Color]);

% Copied both figures to Illustrator for style updates and sizing

%% Extended Data Tables 5-2 to 5-4:
perParasolSynapses = zeros(3, numel(groupNames));
perParasolNeurons = zeros(3, numel(groupNames));

[G, allNames] = findgroups(T18269.Class);
perParasolSynapses(1,:) = splitapply(@sum, T18269.Count, G);
perParasolNeurons(1,:) = splitapply(@numel, T18269.Count, G);

% The rest don't have a group for DB6 so allocate accordingly
idx = find(allNames ~= "DB6");

G = findgroups(T5370.Class);
perParasolSynapses(2,idx) = splitapply(@sum, T5370.Count, G);
perParasolNeurons(2,idx) = splitapply(@numel, T5370.Count, G);

G = findgroups(T5063.Class);
perParasolSynapses(3,idx) = splitapply(@sum, T5063.Count, G);
perParasolNeurons(3,idx) = splitapply(@numel, T5063.Count, G);


pctParasolSynapses = array2table(...
    round(100 * perParasolSynapses ./ sum(perParasolSynapses, 2),2),...
    'RowNames', ["c18269", "c5370", "c5063"],...
    'VariableNames', allNames);
pctParasolNeurons = array2table(...
    round(100 * perParasolNeurons ./ sum(perParasolNeurons, 2),2),...
    'RowNames', ["c18269", "c5370", "c5063"],...
    'VariableNames', allNames);

parasolSynapseTable = array2table(...
    [perParasolSynapses, sum(perParasolSynapses,2)],...
    'RowNames', ["c18269", "c5370", "c5063"],...
    'VariableNames', [allNames; "Total"]);

parasolBipolarTable = array2table(...
    [perParasolNeurons, sum(perParasolNeurons,2)],...
    'RowNames', ["c18269", "c5370", "c5063"],...
    'VariableNames', [allNames; "Total"]);
