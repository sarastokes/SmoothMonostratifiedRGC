function T = getLinkedBipolarTypes(neuron)

    T = countLinkedNeurons(neuron, "RibbonPost");
    T.Label = repmat("", [height(T), 1]);
    for i = 1:height(T)
        T.Label(i) = unique(neuron.links{neuron.links.NeuronID == T.NeuronID(i), 'NeuronLabel'});
    end

    T.Class = repmat("", [height(T), 1]);
    T.Class(contains(T.Label, "DB4")) = "DB4";
    T.Class(contains(T.Label, "DB5")) = "DB5";
    T.Class(contains(T.Label, "DB6")) = "DB6";
    T.Class(contains(T.Label, "giant", "IgnoreCase", true)) = "Giant";
    T.Class(contains(T.Label, ["mBC", "midget"])) = "Midget";

    T.Class(T.NeuronID == 22524) = "DB5";

    T.Class(~ismember(T.Class, ["DB4", "DB5", "Giant", "Midget"])) = "Unclassified";

    T = sortrows(T, "Class");