# SmoothMonostratifiedRGC

Code for replicating the figures and analyses in Patterson, Girresch et al (2023)

This repository relies on [SBFSEM-tools](https://github.com/sarastokes/sbfsem-tools) and requires MATLAB (developed in 2023a but likely compatible with earlier versions).

Some of the utility functions for data import assume you've added the full repository to your search path. Replace the `..` with the full path to wherever the repository folder is located.
```matlab
addpath(genpath('..\SmoothMonostratifiedRGC'))
```

Morphology:
- `Fig1_Morphology.m`: representative reconstructions of a smooth monostratified and parasol RGC
- `DendriticFieldDiameterStats.m`: dendritic field diameters reported in Table 1-1

Synapses:
- `Fig2_Synapses.m`: map of bipolar and amacrine cell input to 1 smooth monostratified RGC and 3 parasol RGCs
- `Fig3_DensityMaps.m`: density maps of the synaptic input above

Bipolar cells:
- `Fig4_SmoothBCs.m`: classified bipolar cells presynaptic to a smooth RGC
- `Fig5_BipolarQuant.m`: Pie charts of bipolar input to 1 smooth monostratified and 3 parasol RGCs (also Tables 5-1 and 5-2)
- `Fig6_ParasolBipolarCells.m`: classified bipolar cells presynaptic to a parasol RGC
- `Fig7_SamplingDensity.m`: synapses per presynaptic bipolar cell (also Tables 7-1 to 7-4)

Smooth monostratified bipolar cell input vs parasol RGC dendritic fields:
- `Fig8_SmoothBipolarDensityMap.m`: comparison of bipolar cell input to 1 smooth monostratified RGC and 2 parasol RGCs
- `Fig8_MixtureOfGaussians`: GMM model fit to smooth RGC synapses to quantify hotspots (also Table 8-1)
- `Fig9_ParasolVsDensity.m`: smooth RGC bipolar cell inputs mapped as distance from parasol RGC dendritic field
- `Fig10_CoolspotSynapses.m`: bipolar cell input to c1321 in region overlapping c18269's dendritic field

`PaperStats.m` contains miscellaneous in-text analyses. The remaining figures (4-1, 6-1, 10-1 and 10-2) are extracted from the Viking annotation software. Additional details on access are included in the paper.