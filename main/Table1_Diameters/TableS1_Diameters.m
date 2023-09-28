%% Extended data table 1-1
% - Last updated: 12Sep2023

%% Smooth RGC
smoothIDs = [1321, 7889];
c7889 = Neuron(7889, 'i');
c1321 = Neuron(1321, 'i');

smoothDiameters = zeros(1, 2);
x = sbfsem.analysis.DendriticFieldHull(c7889, [], false);
smoothDiameters(1) = 2*sqrt(x.data.hullArea / pi);
% I split c1321 at the axon in Viking for this analysis and then merged the
% axon back once I was done.
x = sbfsem.analysis.DendriticFieldHull(c1321, [], false);
% Use area of a circle formula to get equivalent diameter
smoothDiameters(2) = 2*sqrt(x.data.hullArea / pi);
% Area = 2.059e4, Diameter = 161.913
printStat(smoothDiameters, true);

% Print the individual values for the table
for i = 1:numel(smoothIDs)
    fprintf('c%u dendritic field diameter was %.3f\n',...
        smoothIDs(i), smoothDiameters(i));
end
% 153.006 +- 12.597 (n=2)

%% Parasol RGC

parasolIDs = [5053, 5063, 5370, 18269, 21392];
c5063 = Neuron(5063, 'i');
c21392 = Neuron(21392, 'i');
c5370 = Neuron(5370, 'i');
c18269 = Neuron(18269, 'i');
c5035 = Neuron(5035, 'i');

parasolDiameters = zeros(1, numel(parasolIDs));
x = sbfsem.analysis.DendriticFieldHull(c18269, [], false);
parasolDiameters(1) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5063, [], false);
parasolDiameters(2) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c21392, [], false);
parasolDiameters(3) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5370, [], false);
parasolDiameters(4) = 2*sqrt(x.data.hullArea / pi);
x = sbfsem.analysis.DendriticFieldHull(c5035, [], false);
parasolDiameters(5) = 2*sqrt(x.data.hullArea / pi);
printStat(parasolDiameters,  true);
% 56.988 +- 2.066 (n=5)

% Print the individual values for the table
for i = 1:5
    fprintf('c%u dendritic field diameter was %.3f\n',...
        parasolIDs(i), parasolDiameters(i));
end

fprintf('Smooth RGC dendritic field diameter was %.2fx larger than the parasol RGCs\n', mean(smoothDiameters)/mean(parasolDiameters));
% 2.68x larger