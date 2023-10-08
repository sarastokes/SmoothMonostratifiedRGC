# SmoothMonostratifiedRGC

Code for replicating the figures in Patterson, Girresch et al (2023)

This repository relies on [SBFSEM-tools](https://github.com/sarastokes/sbfsem-tools) and requires MATLAB (developed in 2023a but likely compatible with earlier versions).

Morphology:
- `Fig1.m`: representative reconstructions of a smooth monostratified and parasol RGC
- `ENeuroStats.m`: generic statistics on dendritic field and soma

Synaptic input:
- `Fig2.m`: map of bipolar and amacrine cell input to 1 smooth monostratified RGC and 3 parasol RGCs
- `Fig3.m`: density maps of the synaptic input above

Presynaptic bipolar cells:
- `Fig5.m`: Pie charts of bipolar input to 1 smooth monostratified and 3 parasol RGCs (also Extended Figures 5-1 and 5-2)
- `Fig6.m`: bipolar cell input to a smooth monostratified RGC colored by presynaptic bipolar cell type
- `Fig7.m`: synapses per presynaptic bipolar cell (Fig. 7 and Extended Figures 8-1 to 8-4)

Relationship between smooth monostratified bipolar cell input and parasol RGC dendritic fields
- `Fig8.m`: comparison of bipolar cell input to 1 smooth monostratified RGC and 2 parasol RGCs
- `Fig9.m`: smooth RGC bipolar cell inputs mapped as distance from parasol RGC dendritic field

The remaining figures are extracted from the Viking annotation software. Additional details on access are included in the paper.