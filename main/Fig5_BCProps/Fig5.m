%% Figure 5
% - Last updated: 21Sep2023 SSP
% --


db4Color = hex2rgb('be273e');
db5Color = hex2rgb('458ac2');
midgetColor = hex2rgb('5eb672');
giantColor = hex2rgb('f3b026');
db6Color = [0.6 0.6 0.6];

% Smooth RGCs
c1321 = Neuron(1321, 'i', true);
c1321.getLinks();

% Parasol RGCs
c18269 = Neuron(18269, 'i', true);
c18269.getLinks();

c5370 = Neuron(5370, 'i', true);
c5370.getLinks();


T1321 = getLinkedBipolarTypes(c1321);
T18269 = getLinkedBipolarTypes(c18269);
T5370 = getLinkedBipolarTypes(c5370);

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


%% Figure 5B
[G, groupNames] = findgroups([T18269.Class; T5370.Class; T5063.Class]);
counts = splitapply(@sum, [T18269.Count; T5370.Count; T5063.Count], G);
bcParasol = table(groupNames, counts,...
    'VariableNames', ["BipolarType", "Count"]);
bcParasol = sortrows(bcParasol, "Count", "descend");

% Print out info for the figure legend
idx = bcParasol.BipolarType == "Unclassified";
fprintf('Unclassified for fig legend: %.1f%% (%u of %u)\n',...
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

%% Explore:
perParasolSynapses = zeros(3, numel(groupNames));
perParasolNeurons = zeros(3, numel(groupNames));

[G, iNames] = findgroups(T18269.Class);
perParasolSynapses(1,:) = splitapply(@sum, T18269.Count, G);
perParasolNeurons(1,:) = splitapply(@numel, T18269.Count, G);

[G, iNames] = findgroups(T5370.Class);
perParasolSynapses(2,[1:2, 4:6]) = splitapply(@sum, T5370.Count, G);
perParasolNeurons(2,[1:2, 4:6]) = splitapply(@numel, T5370.Count, G);

[G, iNames] = findgroups(T5063.Class);
perParasolSynapses(3,[1:2, 4:6]) = splitapply(@sum, T5063.Count, G);
perParasolNeurons(3,[1:2, 4:6]) = splitapply(@numel, T5063.Count, G);

sum(perParasolSynapses, 2)'
sum(perParasolNeurons, 2)'

pctParasolSynapses = round(100 * perParasolSynapses ./ sum(perParasolSynapses, 2),2);
pctParasolNeurons = round(100 * perParasolNeurons ./ sum(perParasolNeurons, 2),2);