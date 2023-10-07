function xyz = getBipolarSynapseXYZByType(neuron, bcType)


    T = getLinkedBipolarTypes(neuron);

    IDs = T{T.Class == bcType, 'NeuronID'};

    xyz = neuron.links{neuron.links.SynapseType == "RibbonPost" & ...
        ismember(neuron.links.NeuronID, IDs), 'SynapseXYZ'};