function T = getLinkedBipolarTypes(neuron)
%
% Syntax:
%   T = getLinkedBipolarTypes(neuron)

    T = countLinkedNeurons(neuron, "RibbonPost");
    T.Label = repmat("", [height(T), 1]);
    for i = 1:height(T)
        iLabel = unique(neuron.links{neuron.links.NeuronID == T.NeuronID(i), "NeuronLabel"});
        if ~isempty(iLabel)
            T.Label(i) = iLabel;
        end
    end

    T.Class = repmat("", [height(T), 1]);
    T.Class(contains(T.Label, "DB4")) = "DB4";
    T.Class(contains(T.Label, "DB5")) = "DB5";
    T.Class(contains(T.Label, "DB6")) = "DB6";
    T.Class(contains(T.Label, "giant", "IgnoreCase", true)) = "Giant";
    T.Class(contains(T.Label, ["mBC", "midget"], "IgnoreCase", true)) = "Midget";

    T.Class(~ismember(T.Class, ["DB4", "DB5", "DB6", "Giant", "Midget"])) = "Unclassified";

    T = sortrows(T, "Class");